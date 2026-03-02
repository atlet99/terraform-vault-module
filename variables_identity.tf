###############################################################################
# Identity Entities, Groups, Aliases
###############################################################################

variable "identity_entities" {
  description = "Map of identity entities to create."
  type = map(object({
    name              = optional(string, null)
    metadata          = optional(map(string), null)
    policies          = optional(list(string), null)
    external_policies = optional(bool, false)
    disabled          = optional(bool, false)
    namespace         = optional(string, null)
  }))
  default = {}
}

variable "identity_groups" {
  description = "Map of identity groups to create."
  type = map(object({
    name                       = optional(string, null)
    type                       = optional(string, "internal")
    metadata                   = optional(map(string), null)
    policies                   = optional(list(string), null)
    external_policies          = optional(bool, false)
    member_group_ids           = optional(list(string), null)
    member_entity_ids          = optional(list(string), null)
    external_member_entity_ids = optional(bool, false)
    external_member_group_ids  = optional(bool, false)
    namespace                  = optional(string, null)
  }))
  default = {}
}

variable "identity_entity_aliases" {
  description = "Map of identity entity aliases to create."
  type = map(object({
    name            = string
    mount_accessor  = string
    canonical_id    = string
    custom_metadata = optional(map(string), null)
    namespace       = optional(string, null)
  }))
  default = {}
}

variable "identity_group_aliases" {
  description = "Map of identity group aliases to create."
  type = map(object({
    name           = string
    mount_accessor = string
    canonical_id   = string
    namespace      = optional(string, null)
  }))
  default = {}
}

variable "identity_group_memberships" {
  description = "Map of identity group memberships to create (member_entity_ids)."
  type = map(object({
    group_id          = string
    member_entity_ids = list(string)
    exclusive         = optional(bool, true)
    namespace         = optional(string, null)
  }))
  default = {}
}

variable "identity_entity_policies" {
  description = "Map of identity entity policy assignments."
  type = map(object({
    entity_id = string
    policies  = list(string)
    exclusive = optional(bool, true)
    namespace = optional(string, null)
  }))
  default = {}
}

variable "identity_group_policies" {
  description = "Map of identity group policy assignments."
  type = map(object({
    group_id  = string
    policies  = list(string)
    exclusive = optional(bool, true)
    namespace = optional(string, null)
  }))
  default = {}
}

variable "identity_group_member_group_ids" {
  description = "Map of identity group member group assignments."
  type = map(object({
    group_id         = string
    member_group_ids = list(string)
    exclusive        = optional(bool, true)
    namespace        = optional(string, null)
  }))
  default = {}
}

###############################################################################
# Identity OIDC
###############################################################################

variable "identity_oidc_keys" {
  description = "Map of Identity OIDC keys."
  type = map(object({
    name               = string
    algorithm          = optional(string, "RS256")
    allowed_client_ids = optional(list(string), null)
    verification_ttl   = optional(number, null)
    rotation_period    = optional(number, null)
    namespace          = optional(string, null)
  }))
  default = {}
}

variable "identity_oidc_clients" {
  description = "Map of Identity OIDC clients."
  type = map(object({
    name             = string
    key              = optional(string, "default")
    redirect_uris    = optional(list(string), null)
    assignments      = optional(list(string), null)
    id_token_ttl     = optional(number, null)
    access_token_ttl = optional(number, null)
    client_type      = optional(string, "confidential")
    namespace        = optional(string, null)
  }))
  default = {}
}

variable "identity_oidc_scopes" {
  description = "A map of Identity OIDC scopes."
  type = map(object({
    name        = string
    template    = optional(string)
    description = optional(string)
    namespace   = optional(string)
  }))
  default = {}
}

variable "identity_oidc_assignments" {
  description = "A map of Identity OIDC assignments."
  type = map(object({
    name       = string
    entity_ids = optional(list(string))
    group_ids  = optional(list(string))
    namespace  = optional(string)
  }))
  default = {}
}

variable "identity_oidc_providers" {
  description = "A map of Identity OIDC providers."
  type = map(object({
    name               = string
    https_enabled      = optional(bool, true)
    issuer_host        = optional(string)
    allowed_client_ids = optional(list(string))
    scopes_supported   = optional(list(string))
    namespace          = optional(string)
  }))
  default = {}
}

variable "identity_oidc_roles" {
  description = "A map of Identity OIDC roles."
  type = map(object({
    name      = string
    key       = string
    template  = optional(string)
    ttl       = optional(number, 86400)
    client_id = optional(string)
    namespace = optional(string)
  }))
  default = {}
}

###############################################################################
# MFA Methods
###############################################################################

variable "identity_mfa_totp" {
  description = "Map of Identity MFA TOTP methods."
  type = map(object({
    issuer                  = string
    period                  = optional(number, 30)
    key_size                = optional(number, 20)
    qr_size                 = optional(number, 200)
    algorithm               = optional(string, "SHA1")
    digits                  = optional(number, 6)
    skew                    = optional(number, 1)
    max_validation_attempts = optional(number, 5)
    namespace               = optional(string, null)
  }))
  default = {}
}

variable "identity_mfa_okta" {
  description = "A map of Okta MFA methods."
  type = map(object({
    name            = string
    mount_accessor  = string
    username_format = optional(string)
    org_name        = string
    api_token       = string
    base_url        = optional(string, "okta.com")
    primary_email   = optional(bool, false)
    namespace       = optional(string)
  }))
  default = {}
}

variable "identity_mfa_duo" {
  description = "A map of Duo MFA methods."
  type = map(object({
    name            = string
    mount_accessor  = string
    username_format = optional(string)
    secret_key      = string
    integration_key = string
    api_hostname    = string
    push_info       = optional(string)
    namespace       = optional(string)
  }))
  default = {}
}

variable "identity_mfa_pingid" {
  description = "A map of PingID MFA methods."
  type = map(object({
    name                 = string
    mount_accessor       = string
    username_format      = optional(string)
    settings_file_base64 = string
    namespace            = optional(string)
  }))
  default = {}
}

###############################################################################
# Identity & Security Enforcements
###############################################################################

variable "identity_mfa_login_enforcements" {
  description = "A map of MFA login enforcement configurations. Ties MFA methods to specific auth paths, entity IDs, or group IDs."
  type = map(object({
    name                  = string
    mfa_method_ids        = list(string)
    auth_method_accessors = optional(set(string))
    auth_method_types     = optional(set(string))
    identity_entity_ids   = optional(set(string))
    identity_group_ids    = optional(set(string))
    namespace             = optional(string)
  }))
  default = {}
}
