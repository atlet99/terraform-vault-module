variable "namespace" {
  description = "Default Vault Enterprise namespace."
  type        = string
  default     = null
}

###############################################################################
# Secrets Engine Mounts
###############################################################################

variable "mounts" {
  description = "Map of secrets engine mounts to create."
  type = map(object({
    path                         = string
    type                         = string
    description                  = optional(string, null)
    default_lease_ttl_seconds    = optional(number, null)
    max_lease_ttl_seconds        = optional(number, null)
    local                        = optional(bool, false)
    seal_wrap                    = optional(bool, false)
    external_entropy_access      = optional(bool, false)
    namespace                    = optional(string, null)
    options                      = optional(map(string), null)
    listing_visibility           = optional(string, null)
    allowed_managed_keys         = optional(set(string), null)
    audit_non_hmac_request_keys  = optional(list(string), null)
    audit_non_hmac_response_keys = optional(list(string), null)
    passthrough_request_headers  = optional(list(string), null)
    allowed_response_headers     = optional(list(string), null)
    delegated_auth_accessors     = optional(list(string), null)
    plugin_version               = optional(string, null)
    identity_token_key           = optional(string, null)
    force_no_cache               = optional(bool, false)
  }))
  default = {}
}

###############################################################################
# Auth Backends (generic)
###############################################################################

variable "auth_backends" {
  description = "Map of auth backends to enable."
  type = map(object({
    type            = string
    path            = optional(string, null)
    description     = optional(string, null)
    local           = optional(bool, false)
    namespace       = optional(string, null)
    disable_remount = optional(bool, false)
    tune = optional(object({
      default_lease_ttl            = optional(string, null)
      max_lease_ttl                = optional(string, null)
      listing_visibility           = optional(string, null)
      audit_non_hmac_request_keys  = optional(list(string), null)
      audit_non_hmac_response_keys = optional(list(string), null)
      passthrough_request_headers  = optional(list(string), null)
      allowed_response_headers     = optional(list(string), null)
      token_type                   = optional(string, null)
    }), null)
  }))
  default = {}
}

###############################################################################
# Policies
###############################################################################

variable "policies" {
  description = "Map of Vault policies to create. The value of 'policy' is an HCL policy string."
  type = map(object({
    name      = string
    policy    = string
    namespace = optional(string, null)
  }))
  default = {}
}

###############################################################################
# Audit Devices
###############################################################################

variable "audit_devices" {
  description = "Map of audit devices to enable."
  type = map(object({
    type        = string
    path        = optional(string, null)
    description = optional(string, null)
    local       = optional(bool, false)
    namespace   = optional(string, null)
    options     = map(string)
  }))
  default = {}
}

###############################################################################
# KV-V2 Backend Configuration
###############################################################################

variable "kv_secret_backend_v2_config" {
  description = "Map of KV-V2 backend-level configurations."
  type = map(object({
    mount                = string
    namespace            = optional(string, null)
    max_versions         = optional(number, null)
    cas_required         = optional(bool, null)
    delete_version_after = optional(number, null)
  }))
  default = {}
}

###############################################################################
# KV-V2 Secrets
###############################################################################

variable "kv_secrets_v2" {
  description = "Map of KV-V2 secrets to write."
  type = map(object({
    mount               = string
    name                = string
    namespace           = optional(string, null)
    cas                 = optional(number, null)
    disable_read        = optional(bool, false)
    delete_all_versions = optional(bool, false)
    data_json           = optional(string, null)
    custom_metadata = optional(object({
      max_versions         = optional(number, null)
      cas_required         = optional(bool, null)
      delete_version_after = optional(number, null)
      data                 = optional(map(string), null)
    }), null)
  }))
  default = {}
}

###############################################################################
# Namespaces (Vault Enterprise)
###############################################################################

variable "namespaces" {
  description = "Map of Vault Enterprise namespaces to create."
  type = map(object({
    path            = string
    namespace       = optional(string, null)
    custom_metadata = optional(map(string), null)
  }))
  default = {}
}

###############################################################################
# Generic Endpoints
###############################################################################

variable "generic_endpoints" {
  description = "Map of generic endpoints (vault write)."
  type = map(object({
    path                 = string
    namespace            = optional(string, null)
    data_json            = string
    disable_read         = optional(bool, false)
    disable_delete       = optional(bool, false)
    ignore_absent_fields = optional(bool, true)
    write_fields         = optional(list(string), null)
  }))
  default = {}
}

###############################################################################
# Password Policies
###############################################################################

variable "password_policies" {
  description = "Map of Password Policies to create."
  type = map(object({
    name           = string
    policy         = string
    entropy_source = optional(string, null)
    namespace      = optional(string, null)
  }))
  default = {}
}
