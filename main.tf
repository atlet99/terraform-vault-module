###############################################################################
# Secrets Engine Mounts
###############################################################################

resource "vault_mount" "this" {
  for_each = var.mounts

  path                         = each.value.path
  type                         = each.value.type
  description                  = each.value.description
  default_lease_ttl_seconds    = each.value.default_lease_ttl_seconds
  max_lease_ttl_seconds        = each.value.max_lease_ttl_seconds
  local                        = each.value.local
  seal_wrap                    = each.value.seal_wrap
  external_entropy_access      = each.value.external_entropy_access
  namespace                    = each.value.namespace
  options                      = each.value.options
  listing_visibility           = each.value.listing_visibility
  allowed_managed_keys         = each.value.allowed_managed_keys
  audit_non_hmac_request_keys  = each.value.audit_non_hmac_request_keys
  audit_non_hmac_response_keys = each.value.audit_non_hmac_response_keys
  passthrough_request_headers  = each.value.passthrough_request_headers
  allowed_response_headers     = each.value.allowed_response_headers
  delegated_auth_accessors     = each.value.delegated_auth_accessors
  plugin_version               = each.value.plugin_version
  identity_token_key           = each.value.identity_token_key
  force_no_cache               = each.value.force_no_cache
}

###############################################################################
# Auth Backends
###############################################################################

resource "vault_auth_backend" "this" {
  for_each = var.auth_backends

  type            = each.value.type
  path            = each.value.path
  description     = each.value.description
  local           = each.value.local
  namespace       = each.value.namespace
  disable_remount = each.value.disable_remount

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

###############################################################################
# Policies
###############################################################################

resource "vault_policy" "this" {
  for_each = var.policies

  name      = each.value.name
  policy    = each.value.policy
  namespace = each.value.namespace
}

###############################################################################
# Audit Devices
###############################################################################

resource "vault_audit" "this" {
  for_each = var.audit_devices

  type        = each.value.type
  path        = each.value.path
  description = each.value.description
  local       = each.value.local
  namespace   = each.value.namespace
  options     = each.value.options
}

###############################################################################
# Kubernetes Auth Backends
###############################################################################

resource "vault_auth_backend" "kubernetes" {
  for_each = var.kubernetes_auth_backends

  type        = "kubernetes"
  path        = each.value.path
  description = each.value.description
  namespace   = each.value.namespace
}

resource "vault_kubernetes_auth_backend_config" "this" {
  for_each = var.kubernetes_auth_backends

  backend                           = vault_auth_backend.kubernetes[each.key].path
  namespace                         = each.value.namespace
  kubernetes_host                   = each.value.kubernetes_host
  kubernetes_ca_cert                = each.value.kubernetes_ca_cert
  token_reviewer_jwt                = each.value.token_reviewer_jwt
  issuer                            = each.value.issuer
  disable_iss_validation            = each.value.disable_iss_validation
  disable_local_ca_jwt              = each.value.disable_local_ca_jwt
  pem_keys                          = each.value.pem_keys
  use_annotations_as_alias_metadata = each.value.use_annotations_as_alias_metadata
  token_reviewer_jwt_wo             = each.value.token_reviewer_jwt_wo
  token_reviewer_jwt_wo_version     = each.value.token_reviewer_jwt_wo_version
}

locals {
  # Flatten kubernetes auth roles into a single map for for_each
  kubernetes_auth_roles = merge([
    for backend_key, backend in var.kubernetes_auth_backends : {
      for role_key, role in backend.roles :
      "${backend_key}/${role_key}" => merge(role, {
        backend_key = backend_key
        namespace   = backend.namespace
      })
    }
  ]...)
}

resource "vault_kubernetes_auth_backend_role" "this" {
  for_each = local.kubernetes_auth_roles

  backend                                  = vault_auth_backend.kubernetes[each.value.backend_key].path
  namespace                                = each.value.namespace
  role_name                                = each.value.role_name
  bound_service_account_names              = each.value.bound_service_account_names
  bound_service_account_namespaces         = each.value.bound_service_account_namespaces
  audience                                 = each.value.audience
  alias_name_source                        = each.value.alias_name_source
  token_ttl                                = each.value.token_ttl
  token_max_ttl                            = each.value.token_max_ttl
  token_period                             = each.value.token_period
  token_policies                           = each.value.token_policies
  token_bound_cidrs                        = each.value.token_bound_cidrs
  token_explicit_max_ttl                   = each.value.token_explicit_max_ttl
  token_no_default_policy                  = each.value.token_no_default_policy
  token_num_uses                           = each.value.token_num_uses
  token_type                               = each.value.token_type
  bound_service_account_namespace_selector = each.value.bound_service_account_namespace_selector
}

###############################################################################
# KV-V2 Backend Configuration
###############################################################################

resource "vault_kv_secret_backend_v2" "this" {
  for_each = var.kv_secret_backend_v2_config

  mount                = each.value.mount
  namespace            = each.value.namespace
  max_versions         = each.value.max_versions
  cas_required         = each.value.cas_required
  delete_version_after = each.value.delete_version_after
}

###############################################################################
# KV-V2 Secrets
###############################################################################

resource "vault_kv_secret_v2" "this" {
  for_each = var.kv_secrets_v2

  mount               = each.value.mount
  name                = each.value.name
  namespace           = each.value.namespace
  cas                 = each.value.cas
  disable_read        = each.value.disable_read
  delete_all_versions = each.value.delete_all_versions
  data_json           = each.value.data_json

  dynamic "custom_metadata" {
    for_each = each.value.custom_metadata != null ? [each.value.custom_metadata] : []
    content {
      max_versions         = custom_metadata.value.max_versions
      cas_required         = custom_metadata.value.cas_required
      delete_version_after = custom_metadata.value.delete_version_after
      data                 = custom_metadata.value.data
    }
  }
}

###############################################################################
# Namespaces (Vault Enterprise)
###############################################################################

resource "vault_namespace" "this" {
  for_each = var.namespaces

  path            = each.value.path
  namespace       = each.value.namespace
  custom_metadata = each.value.custom_metadata
}

###############################################################################
# Generic Endpoints
###############################################################################

resource "vault_generic_endpoint" "this" {
  for_each = var.generic_endpoints

  path                 = each.value.path
  namespace            = each.value.namespace
  data_json            = each.value.data_json
  disable_read         = each.value.disable_read
  disable_delete       = each.value.disable_delete
  ignore_absent_fields = each.value.ignore_absent_fields
  write_fields         = each.value.write_fields
}
###############################################################################
# Identity Entities
###############################################################################

resource "vault_identity_entity" "this" {
  for_each = var.identity_entities

  name              = each.value.name != null ? each.value.name : each.key
  metadata          = each.value.metadata
  policies          = each.value.policies
  external_policies = each.value.external_policies
  disabled          = each.value.disabled
  namespace         = each.value.namespace
}

###############################################################################
# Identity Groups
###############################################################################

resource "vault_identity_group" "this" {
  for_each = var.identity_groups

  name                       = each.value.name != null ? each.value.name : each.key
  type                       = each.value.type
  metadata                   = each.value.metadata
  policies                   = each.value.policies
  external_policies          = each.value.external_policies
  member_group_ids           = each.value.member_group_ids
  member_entity_ids          = each.value.member_entity_ids
  external_member_entity_ids = each.value.external_member_entity_ids
  external_member_group_ids  = each.value.external_member_group_ids
  namespace                  = each.value.namespace
}

###############################################################################
# Identity Aliases
###############################################################################

resource "vault_identity_entity_alias" "this" {
  for_each = var.identity_entity_aliases

  name            = each.value.name
  mount_accessor  = each.value.mount_accessor
  canonical_id    = each.value.canonical_id
  custom_metadata = each.value.custom_metadata
  namespace       = each.value.namespace
}

resource "vault_identity_group_alias" "this" {
  for_each = var.identity_group_aliases

  name           = each.value.name
  mount_accessor = each.value.mount_accessor
  canonical_id   = each.value.canonical_id
  namespace      = each.value.namespace
}

###############################################################################
# AppRole Auth Roles
###############################################################################

resource "vault_approle_auth_backend_role" "this" {
  for_each = var.approle_auth_roles

  role_name               = each.value.role_name
  backend                 = each.value.backend
  role_id                 = each.value.role_id
  bind_secret_id          = each.value.bind_secret_id
  secret_id_bound_cidrs   = each.value.secret_id_bound_cidrs
  secret_id_num_uses      = each.value.secret_id_num_uses
  secret_id_ttl           = each.value.secret_id_ttl
  local_secret_ids        = each.value.local_secret_ids
  token_ttl               = each.value.token_ttl
  token_max_ttl           = each.value.token_max_ttl
  token_period            = each.value.token_period
  token_policies          = each.value.token_policies
  token_bound_cidrs       = each.value.token_bound_cidrs
  token_explicit_max_ttl  = each.value.token_explicit_max_ttl
  token_no_default_policy = each.value.token_no_default_policy
  token_num_uses          = each.value.token_num_uses
  token_type              = each.value.token_type
  namespace               = each.value.namespace
}

###############################################################################
# JWT/OIDC Auth Roles
###############################################################################

resource "vault_jwt_auth_backend_role" "this" {
  for_each = var.jwt_oidc_auth_roles

  role_name                    = each.value.role_name
  backend                      = each.value.backend
  role_type                    = each.value.role_type
  bound_audiences              = each.value.bound_audiences
  user_claim                   = each.value.user_claim
  user_claim_json_pointer      = each.value.user_claim_json_pointer
  clock_skew_leeway            = each.value.clock_skew_leeway
  expiration_leeway            = each.value.expiration_leeway
  not_before_leeway            = each.value.not_before_leeway
  allowed_redirect_uris        = each.value.allowed_redirect_uris
  bound_subject                = each.value.bound_subject
  oidc_scopes                  = each.value.oidc_scopes
  bound_claims_type            = each.value.bound_claims_type
  bound_claims                 = each.value.bound_claims
  disable_bound_claims_parsing = each.value.disable_bound_claims_parsing
  claim_mappings               = each.value.claim_mappings
  groups_claim                 = each.value.groups_claim
  verbose_oidc_logging         = each.value.verbose_oidc_logging
  max_age                      = each.value.max_age
  token_ttl                    = each.value.token_ttl
  token_max_ttl                = each.value.token_max_ttl
  token_period                 = each.value.token_period
  token_policies               = each.value.token_policies
  token_bound_cidrs            = each.value.token_bound_cidrs
  token_explicit_max_ttl       = each.value.token_explicit_max_ttl
  token_no_default_policy      = each.value.token_no_default_policy
  token_num_uses               = each.value.token_num_uses
  token_type                   = each.value.token_type
  namespace                    = each.value.namespace
}

###############################################################################
# Transit Keys
###############################################################################

resource "vault_transit_secret_backend_key" "this" {
  for_each = var.transit_keys

  name                   = each.value.name
  backend                = each.value.backend
  type                   = each.value.type
  deletion_allowed       = each.value.deletion_allowed
  derived                = each.value.derived
  exportable             = each.value.exportable
  allow_plaintext_backup = each.value.allow_plaintext_backup
  auto_rotate_period     = each.value.auto_rotate_period
  min_decryption_version = each.value.min_decryption_version
  min_encryption_version = each.value.min_encryption_version
  context                = each.value.context
  key_size               = each.value.key_size
  namespace              = each.value.namespace
}

###############################################################################
# Password Policies
###############################################################################

resource "vault_password_policy" "this" {
  for_each = var.password_policies

  name           = each.value.name
  policy         = each.value.policy
  entropy_source = each.value.entropy_source
  namespace      = each.value.namespace
}

###############################################################################
# Identity Group Memberships
###############################################################################

resource "vault_identity_group_member_entity_ids" "this" {
  for_each = var.identity_group_memberships

  group_id          = each.value.group_id
  member_entity_ids = each.value.member_entity_ids
  exclusive         = each.value.exclusive
  namespace         = each.value.namespace
}
