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
# Auth Backends
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
# Kubernetes Auth Backends
###############################################################################

variable "kubernetes_auth_backends" {
  description = "Map of Kubernetes auth backend configurations. Each entry creates an auth backend, its config, and associated roles."
  type = map(object({
    path                              = optional(string, "kubernetes")
    description                       = optional(string, null)
    namespace                         = optional(string, null)
    kubernetes_host                   = string
    kubernetes_ca_cert                = optional(string, null)
    token_reviewer_jwt                = optional(string, null)
    issuer                            = optional(string, null)
    disable_iss_validation            = optional(bool, true)
    disable_local_ca_jwt              = optional(bool, false)
    pem_keys                          = optional(list(string), null)
    use_annotations_as_alias_metadata = optional(bool, null)
    token_reviewer_jwt_wo             = optional(string, null)
    token_reviewer_jwt_wo_version     = optional(number, null)

    roles = optional(map(object({
      role_name                                = string
      bound_service_account_names              = list(string)
      bound_service_account_namespaces         = optional(list(string), ["default"])
      audience                                 = optional(string, null)
      alias_name_source                        = optional(string, null)
      token_ttl                                = optional(number, null)
      token_max_ttl                            = optional(number, null)
      token_period                             = optional(number, null)
      token_policies                           = optional(list(string), null)
      token_bound_cidrs                        = optional(list(string), null)
      token_explicit_max_ttl                   = optional(number, null)
      token_no_default_policy                  = optional(bool, null)
      token_num_uses                           = optional(number, null)
      token_type                               = optional(string, null)
      bound_service_account_namespace_selector = optional(string, null)
    })), {})
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
# Identity Entities
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

###############################################################################
# Identity Groups
###############################################################################

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

###############################################################################
# Identity Aliases
###############################################################################

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

###############################################################################
# AppRole Auth Roles
###############################################################################

variable "approle_auth_roles" {
  description = "Map of AppRole auth backend roles to create."
  type = map(object({
    role_name               = string
    backend                 = optional(string, "approle")
    role_id                 = optional(string, null)
    bind_secret_id          = optional(bool, true)
    secret_id_bound_cidrs   = optional(set(string), null)
    secret_id_num_uses      = optional(number, null)
    secret_id_ttl           = optional(number, null)
    local_secret_ids        = optional(bool, false)
    token_ttl               = optional(number, null)
    token_max_ttl           = optional(number, null)
    token_period            = optional(number, null)
    token_policies          = optional(list(string), null)
    token_bound_cidrs       = optional(list(string), null)
    token_explicit_max_ttl  = optional(number, null)
    token_no_default_policy = optional(bool, null)
    token_num_uses          = optional(number, null)
    token_type              = optional(string, null)
    namespace               = optional(string, null)
  }))
  default = {}
}

###############################################################################
# JWT/OIDC Auth Roles
###############################################################################

variable "jwt_oidc_auth_roles" {
  description = "Map of JWT/OIDC auth backend roles to create."
  type = map(object({
    role_name                    = string
    backend                      = optional(string, "jwt")
    role_type                    = optional(string, "oidc")
    bound_audiences              = optional(set(string), null)
    user_claim                   = string
    user_claim_json_pointer      = optional(bool, false)
    clock_skew_leeway            = optional(number, 0)
    expiration_leeway            = optional(number, 0)
    not_before_leeway            = optional(number, 0)
    allowed_redirect_uris        = optional(set(string), null)
    bound_subject                = optional(string, null)
    oidc_scopes                  = optional(set(string), null)
    bound_claims_type            = optional(string, null)
    bound_claims                 = optional(map(string), null)
    disable_bound_claims_parsing = optional(bool, false)
    claim_mappings               = optional(map(string), null)
    groups_claim                 = optional(string, null)
    verbose_oidc_logging         = optional(bool, false)
    max_age                      = optional(number, null)
    token_ttl                    = optional(number, null)
    token_max_ttl                = optional(number, null)
    token_period                 = optional(number, null)
    token_policies               = optional(list(string), null)
    token_bound_cidrs            = optional(list(string), null)
    token_explicit_max_ttl       = optional(number, null)
    token_no_default_policy      = optional(bool, null)
    token_num_uses               = optional(number, null)
    token_type                   = optional(string, null)
    namespace                    = optional(string, null)
  }))
  default = {}
}

###############################################################################
# Transit Keys
###############################################################################

variable "transit_keys" {
  description = "Map of Transit secret backend keys to create."
  type = map(object({
    name                   = string
    backend                = string
    type                   = optional(string, "aes256-gcm96")
    deletion_allowed       = optional(bool, false)
    derived                = optional(bool, false)
    exportable             = optional(bool, false)
    allow_plaintext_backup = optional(bool, false)
    auto_rotate_period     = optional(number, null)
    min_decryption_version = optional(number, 1)
    min_encryption_version = optional(number, 0)
    context                = optional(string, null)
    key_size               = optional(number, 0)
    namespace              = optional(string, null)
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

###############################################################################
# Identity Group Memberships
###############################################################################

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

# -- Phase 3 Improvements ----------------------------------------------------

variable "database_connections" {
  description = "Map of Database secret backend connections."
  type = map(object({
    name              = string
    backend           = string
    allowed_roles     = optional(list(string), null)
    plugin_name       = optional(string, null)
    verify_connection = optional(bool, true)
    namespace         = optional(string, null)

    postgresql = optional(object({
      connection_url          = string
      max_open_connections    = optional(number, null)
      max_idle_connections    = optional(number, null)
      max_connection_lifetime = optional(number, null)
      username_template       = optional(string, null)
    }), null)

    mysql = optional(object({
      connection_url          = string
      max_open_connections    = optional(number, null)
      max_idle_connections    = optional(number, null)
      max_connection_lifetime = optional(number, null)
      username_template       = optional(string, null)
    }), null)
  }))
  default = {}
}

variable "database_roles" {
  description = "Map of Database secret backend roles (dynamic credentials)."
  type = map(object({
    name                  = string
    backend               = string
    db_name               = string
    creation_statements   = list(string)
    revocation_statements = optional(list(string), null)
    default_ttl           = optional(number, null)
    max_ttl               = optional(number, null)
    namespace             = optional(string, null)
  }))
  default = {}
}

variable "database_static_roles" {
  description = "Map of Database secret backend static roles."
  type = map(object({
    name                = string
    backend             = string
    db_name             = string
    username            = string
    rotation_period     = number
    rotation_window     = optional(number, null)
    rotation_statements = optional(list(string), null)
    namespace           = optional(string, null)
  }))
  default = {}
}

variable "pki_roles" {
  description = "Map of PKI secret backend roles."
  type = map(object({
    name               = string
    backend            = string
    ttl                = optional(string, null)
    max_ttl            = optional(string, null)
    allow_localhost    = optional(bool, true)
    allowed_domains    = optional(list(string), null)
    allow_bare_domains = optional(bool, false)
    allow_subdomains   = optional(bool, false)
    allow_any_name     = optional(bool, false)
    enforce_hostnames  = optional(bool, true)
    allow_ip_sans      = optional(bool, true)
    server_flag        = optional(bool, true)
    client_flag        = optional(bool, true)
    key_type           = optional(string, "rsa")
    key_bits           = optional(number, 2048)
    no_store           = optional(bool, false)
    namespace          = optional(string, null)
  }))
  default = {}
}

variable "aws_roles" {
  description = "Map of AWS secret backend roles."
  type = map(object({
    name            = string
    backend         = string
    credential_type = string # iam_user, assumed_role, federation_token
    policy_arns     = optional(list(string), null)
    policy_document = optional(string, null)
    role_arns       = optional(list(string), null)
    default_sts_ttl = optional(number, null)
    max_sts_ttl     = optional(number, null)
    iam_groups      = optional(list(string), null)
    namespace       = optional(string, null)
  }))
  default = {}
}

variable "github_auth_backends" {
  description = "Map of GitHub auth backend configurations (organization settings)."
  type = map(object({
    path            = string
    organization    = string
    organization_id = optional(number, null)
    base_url        = optional(string, null)
    description     = optional(string, null)
    namespace       = optional(string, null)
    tune = optional(object({
      default_lease_ttl  = optional(string, null)
      max_lease_ttl      = optional(string, null)
      listing_visibility = optional(string, null)
      token_type         = optional(string, null)
    }), null)
  }))
  default = {}
}
# -- Phase 4 Improvements ----------------------------------------------------

variable "ssh_roles" {
  description = "Map of SSH secret backend roles."
  type = map(object({
    name                     = string
    backend                  = string
    key_type                 = string
    allow_bare_domains       = optional(bool, false)
    allow_host_certificates  = optional(bool, false)
    allow_subdomains         = optional(bool, false)
    allow_user_certificates  = optional(bool, false)
    allow_user_key_ids       = optional(bool, false)
    allowed_critical_options = optional(string, null)
    allowed_domains_template = optional(bool, null)
    allowed_domains          = optional(string, null)
    cidr_list                = optional(string, null)
    allowed_extensions       = optional(string, null)
    default_extensions       = optional(map(string), null)
    default_critical_options = optional(map(string), null)
    allowed_users_template   = optional(bool, false)
    allowed_users            = optional(string, null)
    default_user             = optional(string, null)
    default_user_template    = optional(bool, null)
    key_id_format            = optional(string, null)
    algorithm_signer         = optional(string, null)
    max_ttl                  = optional(string, null)
    ttl                      = optional(string, null)
    not_before_duration      = optional(string, null)
    allow_empty_principals   = optional(bool, false)
    allowed_user_key_config = optional(list(object({
      type    = string
      lengths = list(number)
    })), null)
    namespace = optional(string, null)
  }))
  default = {}
}

variable "token_auth_backend_roles" {
  description = "Map of Token auth backend roles."
  type = map(object({
    role_name                = string
    allowed_policies         = optional(set(string), null)
    allowed_policies_glob    = optional(set(string), null)
    disallowed_policies      = optional(set(string), null)
    disallowed_policies_glob = optional(set(string), null)
    orphan                   = optional(bool, false)
    allowed_entity_aliases   = optional(set(string), null)
    renewable                = optional(bool, true)
    path_suffix              = optional(string, "")
    token_ttl                = optional(number, null)
    token_max_ttl            = optional(number, null)
    token_period             = optional(number, null)
    token_explicit_max_ttl   = optional(number, null)
    token_no_default_policy  = optional(bool, null)
    token_num_uses           = optional(number, null)
    token_type               = optional(string, null)
    token_bound_cidrs        = optional(list(string), null)
    namespace                = optional(string, null)
  }))
  default = {}
}

variable "audit_request_headers" {
  description = "Map of Audit request headers to track."
  type = map(object({
    name      = string
    hmac      = optional(bool, false)
    namespace = optional(string, null)
  }))
  default = {}
}

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
