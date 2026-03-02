###############################################################################
# Identity Entities, Groups, Aliases, Memberships
###############################################################################

output "identity_entities" {
  description = "Full identity entity objects keyed by variable key. Contains name and id."
  value = {
    for k, v in vault_identity_entity.this : k => {
      name = v.name
      id   = v.id
    }
  }
}

output "identity_entity_policies" {
  description = "Map of identity entity policy assignment keys to their entity names and policies."
  value = {
    for k, v in vault_identity_entity_policies.this : k => {
      entity_name = v.entity_name
      policies    = v.policies
    }
  }
}

output "identity_entity_ids" {
  description = "Map of identity entity keys to their IDs."
  value       = { for k, v in vault_identity_entity.this : k => v.id }
}

output "identity_groups" {
  description = "Full identity group objects keyed by variable key. Contains name and id."
  value = {
    for k, v in vault_identity_group.this : k => {
      name = v.name
      id   = v.id
    }
  }
}

output "identity_group_policies" {
  description = "Map of identity group policy assignment keys to their group names and policies."
  value = {
    for k, v in vault_identity_group_policies.this : k => {
      group_name = v.group_name
      policies   = v.policies
    }
  }
}

output "identity_group_ids" {
  description = "Map of identity group keys to their IDs."
  value       = { for k, v in vault_identity_group.this : k => v.id }
}

output "identity_entity_aliases" {
  description = "Full identity entity alias objects keyed by variable key. Contains name, id, and canonical_id."
  value = {
    for k, v in vault_identity_entity_alias.this : k => {
      name         = v.name
      id           = v.id
      canonical_id = v.canonical_id
    }
  }
}

output "identity_group_aliases" {
  description = "Full identity group alias objects keyed by variable key. Contains name, id, and canonical_id."
  value = {
    for k, v in vault_identity_group_alias.this : k => {
      name         = v.name
      id           = v.id
      canonical_id = v.canonical_id
    }
  }
}

output "identity_group_memberships" {
  description = "Map of identity group membership keys to their group IDs and member entity IDs."
  value = {
    for k, v in vault_identity_group_member_entity_ids.this : k => {
      group_id          = v.group_id
      member_entity_ids = v.member_entity_ids
    }
  }
}

output "identity_group_member_group_ids" {
  description = "Map of identity group member group assignment keys to their group IDs and member group IDs."
  value = {
    for k, v in vault_identity_group_member_group_ids.this : k => {
      group_id         = v.group_id
      member_group_ids = v.member_group_ids
    }
  }
}

###############################################################################
# Identity OIDC
###############################################################################

output "identity_oidc_keys" {
  description = "Map of Identity OIDC key keys to their names."
  value       = { for k, v in vault_identity_oidc_key.this : k => v.name }
}

output "identity_oidc_clients" {
  description = "Map of Identity OIDC client keys to their names and client IDs."
  value = {
    for k, v in vault_identity_oidc_client.this : k => {
      name      = v.name
      client_id = v.client_id
    }
  }
}

output "identity_oidc_assignments" {
  description = "Map of Identity OIDC assignment keys to their names."
  value       = { for k, v in vault_identity_oidc_assignment.this : k => v.name }
}

output "identity_oidc_scopes" {
  description = "Map of Identity OIDC scope keys to their names."
  value       = { for k, v in vault_identity_oidc_scope.this : k => v.name }
}

output "identity_oidc_roles" {
  description = "Map of Identity OIDC role keys to their names."
  value       = { for k, v in vault_identity_oidc_role.this : k => v.name }
}

output "identity_oidc_providers" {
  description = "Map of Identity OIDC provider keys to their names."
  value       = { for k, v in vault_identity_oidc_provider.this : k => v.name }
}

###############################################################################
# Identity MFA
###############################################################################

output "identity_mfa_totp" {
  description = "Map of Identity MFA TOTP keys to their issuer names and IDs."
  value = {
    for k, v in vault_identity_mfa_totp.this : k => {
      issuer = v.issuer
      id     = v.id
    }
  }
}

output "identity_mfa_duo" {
  description = "Map of Identity MFA Duo keys to their names and IDs."
  value = {
    for k, v in vault_mfa_duo.this : k => {
      name = v.name
      id   = v.id
    }
  }
}

output "identity_mfa_okta" {
  description = "Map of Identity MFA Okta keys to their names and IDs."
  value = {
    for k, v in vault_mfa_okta.this : k => {
      name = v.name
      id   = v.id
    }
  }
}

output "identity_mfa_pingid" {
  description = "Map of Identity MFA PingID keys to their names and IDs."
  value = {
    for k, v in vault_mfa_pingid.this : k => {
      name = v.name
      id   = v.id
    }
  }
}

###############################################################################
# MFA Login Enforcement
###############################################################################

output "identity_mfa_login_enforcements" {
  description = "Map of MFA login enforcement keys to their names and namespace paths."
  value = {
    for k, v in vault_identity_mfa_login_enforcement.this : k => {
      name           = v.name
      namespace_id   = v.namespace_id
      namespace_path = v.namespace_path
    }
  }
}
