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
# Identity Group Memberships
###############################################################################

resource "vault_identity_group_member_entity_ids" "this" {
  for_each = var.identity_group_memberships

  group_id          = each.value.group_id
  member_entity_ids = each.value.member_entity_ids
  exclusive         = each.value.exclusive
  namespace         = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# Identity OIDC & MFA (Phase 4)
###############################################################################

resource "vault_identity_oidc_key" "this" {
  for_each = var.identity_oidc_keys

  name               = each.value.name
  algorithm          = each.value.algorithm
  allowed_client_ids = each.value.allowed_client_ids
  verification_ttl   = each.value.verification_ttl
  rotation_period    = each.value.rotation_period
  namespace          = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_identity_oidc_client" "this" {
  for_each = var.identity_oidc_clients

  name             = each.value.name
  key              = each.value.key
  redirect_uris    = each.value.redirect_uris
  assignments      = each.value.assignments
  id_token_ttl     = each.value.id_token_ttl
  access_token_ttl = each.value.access_token_ttl
  client_type      = each.value.client_type
  namespace        = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_identity_mfa_totp" "this" {
  for_each = var.identity_mfa_totp

  issuer                  = each.value.issuer
  period                  = each.value.period
  key_size                = each.value.key_size
  qr_size                 = each.value.qr_size
  algorithm               = each.value.algorithm
  digits                  = each.value.digits
  skew                    = each.value.skew
  max_validation_attempts = each.value.max_validation_attempts
  namespace               = each.value.namespace != null ? each.value.namespace : var.namespace
}
