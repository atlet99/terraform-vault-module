###############################################################################
# Secrets Sync
###############################################################################

variable "secrets_sync_config" {
  description = "Global configuration for secrets sync."
  type = object({
    disabled       = optional(bool)
    queue_capacity = optional(number)
    namespace      = optional(string)
  })
  default = null
}

variable "secrets_sync_aws_destinations" {
  description = "A map of AWS destinations for secrets sync."
  type = map(object({
    name                      = string
    access_key_id             = optional(string)
    secret_access_key         = optional(string)
    region                    = optional(string)
    role_arn                  = optional(string)
    external_id               = optional(string)
    secret_name_template      = optional(string)
    granularity               = optional(string)
    custom_tags               = optional(map(string))
    allowed_ipv4_addresses    = optional(list(string))
    allowed_ipv6_addresses    = optional(list(string))
    allowed_ports             = optional(list(number))
    disable_strict_networking = optional(bool)
    namespace                 = optional(string)
  }))
  default = {}
}

variable "secrets_sync_azure_destinations" {
  description = "A map of Azure destinations for secrets sync."
  type = map(object({
    name                      = string
    client_id                 = optional(string)
    client_secret             = optional(string)
    tenant_id                 = optional(string)
    key_vault_uri             = optional(string)
    cloud                     = optional(string)
    secret_name_template      = optional(string)
    granularity               = optional(string)
    custom_tags               = optional(map(string))
    allowed_ipv4_addresses    = optional(list(string))
    allowed_ipv6_addresses    = optional(list(string))
    allowed_ports             = optional(list(number))
    disable_strict_networking = optional(bool)
    namespace                 = optional(string)
  }))
  default = {}
}

variable "secrets_sync_gcp_destinations" {
  description = "A map of GCP destinations for secrets sync."
  type = map(object({
    name                      = string
    credentials               = optional(string)
    project_id                = optional(string)
    secret_name_template      = optional(string)
    granularity               = optional(string)
    custom_tags               = optional(map(string))
    replication_locations     = optional(list(string))
    locational_kms_keys       = optional(map(string))
    global_kms_key            = optional(string)
    allowed_ipv4_addresses    = optional(list(string))
    allowed_ipv6_addresses    = optional(list(string))
    allowed_ports             = optional(list(number))
    disable_strict_networking = optional(bool)
    namespace                 = optional(string)
  }))
  default = {}
}

variable "secrets_sync_gh_destinations" {
  description = "A map of GitHub destinations for secrets sync."
  type = map(object({
    name                      = string
    access_token              = optional(string)
    repository_owner          = optional(string)
    repository_name           = optional(string)
    app_name                  = optional(string)
    installation_id           = optional(number)
    secret_name_template      = optional(string)
    granularity               = optional(string)
    secrets_location          = optional(string)
    environment_name          = optional(string)
    allowed_ipv4_addresses    = optional(list(string))
    allowed_ipv6_addresses    = optional(list(string))
    allowed_ports             = optional(list(number))
    disable_strict_networking = optional(bool)
    namespace                 = optional(string)
  }))
  default = {}
}

variable "secrets_sync_associations" {
  description = "A map of associations between secrets and destinations."
  type = map(object({
    type        = string
    name        = string
    mount       = string
    secret_name = string
    namespace   = optional(string)
  }))
  default = {}
}
