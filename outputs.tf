###############################################################################
# Mounts
###############################################################################

output "mounts" {
  description = "Full mount objects keyed by variable key. Contains path, accessor, type, and description."
  value = {
    for k, v in vault_mount.this : k => {
      path        = v.path
      accessor    = v.accessor
      type        = v.type
      description = v.description
    }
  }
}

output "mount_accessors" {
  description = "Map of mount keys to their accessors."
  value       = { for k, v in vault_mount.this : k => v.accessor }
}

output "mount_paths" {
  description = "Map of mount keys to their paths."
  value       = { for k, v in vault_mount.this : k => v.path }
}

###############################################################################
# Auth Backends
###############################################################################

output "auth_backends" {
  description = "Full auth backend objects keyed by variable key. Contains path, accessor, type, and description."
  value = {
    for k, v in vault_auth_backend.this : k => {
      path        = v.path
      accessor    = v.accessor
      type        = v.type
      description = v.description
    }
  }
}

output "auth_backend_accessors" {
  description = "Map of auth backend keys to their accessors."
  value       = { for k, v in vault_auth_backend.this : k => v.accessor }
}

output "auth_backend_paths" {
  description = "Map of auth backend keys to their paths."
  value       = { for k, v in vault_auth_backend.this : k => v.path }
}

###############################################################################
# Policies
###############################################################################

output "policies" {
  description = "Full policy objects keyed by variable key. Contains name and id."
  value = {
    for k, v in vault_policy.this : k => {
      name = v.name
      id   = v.id
    }
  }
}

output "policy_names" {
  description = "Map of policy keys to their names."
  value       = { for k, v in vault_policy.this : k => v.name }
}

###############################################################################
# Audit Devices
###############################################################################

output "audit_devices" {
  description = "Full audit device objects keyed by variable key. Contains path, type, and id."
  value = {
    for k, v in vault_audit.this : k => {
      path = v.path
      type = v.type
      id   = v.id
    }
  }
}

output "audit_device_paths" {
  description = "Map of audit device keys to their paths."
  value       = { for k, v in vault_audit.this : k => v.path }
}

###############################################################################
# Kubernetes Auth
###############################################################################

output "kubernetes_auth_backends" {
  description = "Full Kubernetes auth backend objects keyed by variable key. Contains path, accessor, and id."
  value = {
    for k, v in vault_auth_backend.kubernetes : k => {
      path     = v.path
      accessor = v.accessor
      id       = v.id
    }
  }
}

output "kubernetes_auth_backend_accessors" {
  description = "Map of Kubernetes auth backend keys to their accessors."
  value       = { for k, v in vault_auth_backend.kubernetes : k => v.accessor }
}

output "kubernetes_auth_backend_paths" {
  description = "Map of Kubernetes auth backend keys to their paths."
  value       = { for k, v in vault_auth_backend.kubernetes : k => v.path }
}

output "kubernetes_auth_roles" {
  description = "Map of Kubernetes auth role composite keys (backend/role) to their role names and backend paths."
  value = {
    for k, v in vault_kubernetes_auth_backend_role.this : k => {
      role_name = v.role_name
      backend   = v.backend
    }
  }
}

###############################################################################
# KV-V2 Secrets
###############################################################################

output "kv_secrets_v2" {
  description = "Full KV-V2 secret objects keyed by variable key. Contains path, mount, and name."
  value = {
    for k, v in vault_kv_secret_v2.this : k => {
      path  = v.path
      mount = v.mount
      name  = v.name
    }
  }
}

output "kv_secret_v2_paths" {
  description = "Map of KV-V2 secret keys to their full paths."
  value       = { for k, v in vault_kv_secret_v2.this : k => v.path }
}

output "kv_secret_v2_metadata" {
  description = "Map of KV-V2 secret keys to their metadata."
  value       = { for k, v in vault_kv_secret_v2.this : k => v.metadata }
}

###############################################################################
# Namespaces
###############################################################################

output "namespaces" {
  description = "Full namespace objects keyed by variable key. Contains path, path_fq, namespace_id, and id."
  value = {
    for k, v in vault_namespace.this : k => {
      path         = v.path
      path_fq      = v.path_fq
      namespace_id = v.namespace_id
      id           = v.id
    }
  }
}

output "namespace_ids" {
  description = "Map of namespace keys to their Vault-internal namespace IDs."
  value       = { for k, v in vault_namespace.this : k => v.namespace_id }
}

output "namespace_paths" {
  description = "Map of namespace keys to their fully qualified paths."
  value       = { for k, v in vault_namespace.this : k => v.path_fq }
}

###############################################################################
# Generic Endpoints
###############################################################################

output "generic_endpoints" {
  description = "Full generic endpoint objects keyed by variable key. Contains path, write_data, and write_data_json."
  value = {
    for k, v in vault_generic_endpoint.this : k => {
      path            = v.path
      write_data      = v.write_data
      write_data_json = v.write_data_json
    }
  }
}

output "generic_endpoint_write_data" {
  description = "Map of generic endpoint keys to their write_data maps."
  value       = { for k, v in vault_generic_endpoint.this : k => v.write_data }
}

output "generic_endpoint_write_data_json" {
  description = "Map of generic endpoint keys to their write_data_json strings."
  value       = { for k, v in vault_generic_endpoint.this : k => v.write_data_json }
}
###############################################################################
# Identity Entities
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

output "identity_entity_ids" {
  description = "Map of identity entity keys to their IDs."
  value       = { for k, v in vault_identity_entity.this : k => v.id }
}

###############################################################################
# Identity Groups
###############################################################################

output "identity_groups" {
  description = "Full identity group objects keyed by variable key. Contains name and id."
  value = {
    for k, v in vault_identity_group.this : k => {
      name = v.name
      id   = v.id
    }
  }
}

output "identity_group_ids" {
  description = "Map of identity group keys to their IDs."
  value       = { for k, v in vault_identity_group.this : k => v.id }
}

###############################################################################
# Identity Aliases
###############################################################################

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

###############################################################################
# AppRole Auth Roles
###############################################################################

output "approle_auth_roles" {
  description = "Map of AppRole auth role keys to their role names, role IDs, and backend paths."
  value = {
    for k, v in vault_approle_auth_backend_role.this : k => {
      role_name = v.role_name
      role_id   = v.role_id
      backend   = v.backend
    }
  }
}

###############################################################################
# JWT/OIDC Auth Roles
###############################################################################

output "jwt_oidc_auth_roles" {
  description = "Map of JWT/OIDC auth role keys to their role names and backend paths."
  value = {
    for k, v in vault_jwt_auth_backend_role.this : k => {
      role_name = v.role_name
      backend   = v.backend
    }
  }
}

###############################################################################
# Transit Keys
###############################################################################

output "transit_keys" {
  description = "Map of Transit key keys to their names and backend paths."
  value = {
    for k, v in vault_transit_secret_backend_key.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

###############################################################################
# Password Policies
###############################################################################

output "password_policies" {
  description = "Map of password policy keys to their names."
  value       = { for k, v in vault_password_policy.this : k => v.name }
}

###############################################################################
# Identity Group Memberships
###############################################################################

output "identity_group_memberships" {
  description = "Map of identity group membership keys to their group IDs and member entity IDs."
  value = {
    for k, v in vault_identity_group_member_entity_ids.this : k => {
      group_id          = v.group_id
      member_entity_ids = v.member_entity_ids
    }
  }
}
