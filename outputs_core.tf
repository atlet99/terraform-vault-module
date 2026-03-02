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
# Auth Backends (generic)
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

output "audit_request_headers" {
  description = "Map of audit request header keys to their names and IDs."
  value = {
    for k, v in vault_audit_request_header.this : k => {
      name = v.name
      id   = v.id
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

output "kv_secret_backend_v2_config" {
  description = "Map of KV-V2 secret backend config keys to their mount paths."
  value       = { for k, v in vault_kv_secret_backend_v2.this : k => v.mount }
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
  sensitive = true
}

output "generic_endpoint_write_data" {
  description = "Map of generic endpoint keys to their write_data maps."
  value       = { for k, v in vault_generic_endpoint.this : k => v.write_data }
  sensitive   = true
}

output "generic_endpoint_write_data_json" {
  description = "Map of generic endpoint keys to their write_data_json strings."
  value       = { for k, v in vault_generic_endpoint.this : k => v.write_data_json }
  sensitive   = true
}

###############################################################################
# Password Policies
###############################################################################

output "password_policies" {
  description = "Map of password policy keys to their names."
  value       = { for k, v in vault_password_policy.this : k => v.name }
}

###############################################################################
# Raft Storage Management
###############################################################################

output "raft_autopilot" {
  description = "Raft autopilot configuration ID."
  value       = var.raft_autopilot != null ? vault_raft_autopilot.this[0].id : null
}

output "raft_snapshot_agent_configs" {
  description = "Map of Raft snapshot agent configuration keys to their IDs."
  value       = { for k, v in vault_raft_snapshot_agent_config.this : k => v.id }
}
