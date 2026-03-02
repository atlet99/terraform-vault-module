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
# GitHub Auth Backend (Phase 3)
###############################################################################

resource "vault_github_auth_backend" "this" {
  for_each = var.github_auth_backends

  path            = each.value.path
  organization    = each.value.organization
  organization_id = each.value.organization_id
  base_url        = each.value.base_url
  description     = each.value.description
  namespace       = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl  = tune.value.default_lease_ttl
      max_lease_ttl      = tune.value.max_lease_ttl
      listing_visibility = tune.value.listing_visibility
      token_type         = tune.value.token_type
    }
  }
}

###############################################################################
# Token Auth Backend Roles (Phase 4)
###############################################################################

resource "vault_token_auth_backend_role" "this" {
  for_each = var.token_auth_backend_roles

  role_name                = each.value.role_name
  allowed_policies         = each.value.allowed_policies
  allowed_policies_glob    = each.value.allowed_policies_glob
  disallowed_policies      = each.value.disallowed_policies
  disallowed_policies_glob = each.value.disallowed_policies_glob
  orphan                   = each.value.orphan
  allowed_entity_aliases   = each.value.allowed_entity_aliases
  renewable                = each.value.renewable
  path_suffix              = each.value.path_suffix
  token_ttl                = each.value.token_ttl
  token_max_ttl            = each.value.token_max_ttl
  token_period             = each.value.token_period
  token_explicit_max_ttl   = each.value.token_explicit_max_ttl
  token_no_default_policy  = each.value.token_no_default_policy
  token_num_uses           = each.value.token_num_uses
  token_type               = each.value.token_type
  token_bound_cidrs        = each.value.token_bound_cidrs
  namespace                = each.value.namespace != null ? each.value.namespace : var.namespace
}
