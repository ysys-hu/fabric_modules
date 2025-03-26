/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# inputs
# local._projects - parsed data from yaml as map
# local._projects_config = object({
#   data_overrides = ...
#   data_defaults = ...
# })
# outputs:
# projects - map
locals {
  projects = {
    for k, v in local._projects : lookup(v, "name", k) => merge(v, {
      billing_account = try(coalesce(
        local._projects_config.data_overrides.billing_account,
        try(v.billing_account, null),
        local._projects_config.data_defaults.billing_account
      ), null)
      contacts = coalesce(
        local._projects_config.data_overrides.contacts,
        try(v.contacts, null),
        local._projects_config.data_defaults.contacts
      )
      factories_config = {
        custom_roles = try(
          coalesce(
            local._projects_config.data_overrides.factories_config.custom_roles,
            try(v.factories_config.custom_roles, null),
            local._projects_config.data_defaults.factories_config.custom_roles
          ),
          null
        )
        observability = try(
          coalesce(
            local._projects_config.data_overrides.factories_config.observability,
            try(v.factories_config.observability, null),
            local._projects_config.data_defaults.factories_config.observability
          ),
        null)
        org_policies = try(
          coalesce(
            local._projects_config.data_overrides.factories_config.org_policies,
            try(v.factories_config.org_policies, null),
            local._projects_config.data_defaults.factories_config.org_policies
          ),
        null)
        quotas = try(
          coalesce(
            local._projects_config.data_overrides.factories_config.quotas,
            try(v.factories_config.quotas, null),
            local._projects_config.data_defaults.factories_config.quotas
          ),
        null)
      }
      labels = coalesce(
        try(v.labels, null),
        local._projects_config.data_defaults.labels
      )
      metric_scopes = coalesce(
        try(v.metric_scopes, null),
        local._projects_config.data_defaults.metric_scopes
      )
      org_policies = try(v.org_policies, {})
      parent = coalesce(
        local._projects_config.data_overrides.parent,
        try(v.parent, null),
        local._projects_config.data_defaults.parent
      )
      prefix = coalesce(
        local._projects_config.data_overrides.prefix,
        try(v.prefix, null),
        local._projects_config.data_defaults.prefix
      )
      service_encryption_key_ids = coalesce(
        local._projects_config.data_overrides.service_encryption_key_ids,
        try(v.service_encryption_key_ids, null),
        local._projects_config.data_defaults.service_encryption_key_ids
      )
      services = coalesce(
        local._projects_config.data_overrides.services,
        try(v.services, null),
        local._projects_config.data_defaults.services
      )
      shared_vpc_host_config = (
        try(v.shared_vpc_host_config, null) != null
        ? merge(
          { service_projects = [] },
          v.shared_vpc_host_config
        )
        : null
      )
      shared_vpc_service_config = (
        try(v.shared_vpc_service_config, null) != null
        ? merge(
          {
            host_project             = null
            network_users            = []
            service_agent_iam        = {}
            service_agent_subnet_iam = {}
            service_iam_grants       = []
            network_subnet_users     = {}
          },
          v.shared_vpc_service_config
        )
        : local._projects_config.data_defaults.shared_vpc_service_config
      )
      tag_bindings = coalesce(
        local._projects_config.data_overrides.tag_bindings,
        try(v.tag_bindings, null),
        local._projects_config.data_defaults.tag_bindings
      )
      vpc_sc = (
        local._projects_config.data_overrides.vpc_sc != null
        ? local._projects_config.data_overrides.vpc_sc
        : (
          try(v.vpc_sc, null) != null
          ? merge({
            perimeter_name    = null
            perimeter_bridges = []
            is_dry_run        = false
          }, v.vpc_sc)
          : local._projects_config.data_defaults.vpc_sc
        )
      )
      logging_data_access = coalesce(
        local._projects_config.data_overrides.logging_data_access,
        try(v.logging_data_access, null),
        local._projects_config.data_defaults.logging_data_access
      )
      # non-project resources
      buckets          = try(v.buckets, {})
      service_accounts = try(v.service_accounts, {})
    })
  }
}
