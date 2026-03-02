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
# Namespaces (Vault Enterprise)
###############################################################################

resource "vault_namespace" "this" {
  for_each = var.namespaces

  path            = each.value.path
  namespace       = each.value.namespace
  custom_metadata = each.value.custom_metadata
}
