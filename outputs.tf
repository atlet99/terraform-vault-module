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

# -- Phase 3 Outputs ---------------------------------------------------------

output "database_connections" {
  description = "Map of Database connection keys to their names and backend paths."
  value = {
    for k, v in vault_database_secret_backend_connection.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "database_roles" {
  description = "Map of Database role keys to their names and backend paths."
  value = {
    for k, v in vault_database_secret_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "database_static_roles" {
  description = "Map of Database static role keys to their names and backend paths."
  value = {
    for k, v in vault_database_secret_backend_static_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "pki_roles" {
  description = "Map of PKI role keys to their names and backend paths."
  value = {
    for k, v in vault_pki_secret_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "aws_roles" {
  description = "Map of AWS role keys to their names and backend paths."
  value = {
    for k, v in vault_aws_secret_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "github_auth_backends" {
  description = "Map of GitHub auth backend keys to their paths and organization."
  value = {
    for k, v in vault_github_auth_backend.this : k => {
      path         = v.path
      organization = v.organization
    }
  }
}

# -- Phase 5 Outputs ---------------------------------------------------------

output "azure_secret_backends" {
  description = "Map of Azure secret backend keys to their paths."
  value       = { for k, v in vault_azure_secret_backend.this : k => v.path }
}

output "gcp_secret_backends" {
  description = "Map of GCP secret backend keys to their paths."
  value       = { for k, v in vault_gcp_secret_backend.this : k => v.path }
}

output "ldap_secret_backends" {
  description = "Map of LDAP secret backend keys to their paths."
  value       = { for k, v in vault_ldap_secret_backend.this : k => v.path }
}

output "secrets_sync_config" {
  description = "Secrets sync configuration."
  value       = vault_secrets_sync_config.this
}

output "quota_rate_limits" {
  description = "Map of rate limit quota keys to their names."
  value       = { for k, v in vault_quota_rate_limit.this : k => v.name }
}

output "quota_lease_counts" {
  description = "Map of lease count quota keys to their names."
  value       = { for k, v in vault_quota_lease_count.this : k => v.name }
}

output "identity_oidc_providers" {
  description = "Map of Identity OIDC provider keys to their names."
  value       = { for k, v in vault_identity_oidc_provider.this : k => v.name }
}

###############################################################################
# Additional Secret Engines Outputs
###############################################################################

output "consul_secret_backends" {
  description = "Map of Consul secret backend keys to their paths."
  value       = { for k, v in vault_consul_secret_backend.this : k => v.path }
}

output "nomad_secret_backends" {
  description = "Map of Nomad secret backend keys to their paths."
  value       = { for k, v in vault_nomad_secret_backend.this : k => v.backend }
}

output "mongodbatlas_secret_backends" {
  description = "Map of MongoDB Atlas secret backend keys to their mount paths."
  value       = { for k, v in vault_mongodbatlas_secret_backend.this : k => v.mount }
}

output "rabbitmq_secret_backends" {
  description = "Map of RabbitMQ secret backend keys to their paths."
  value       = { for k, v in vault_rabbitmq_secret_backend.this : k => v.path }
}

output "terraform_cloud_secret_backends" {
  description = "Map of Terraform Cloud secret backend keys to their paths."
  value       = { for k, v in vault_terraform_cloud_secret_backend.this : k => v.backend }
}

output "kmip_secret_backends" {
  description = "Map of KMIP secret backend keys to their paths."
  value       = { for k, v in vault_kmip_secret_backend.this : k => v.path }
}

output "transform_alphabets" {
  description = "Map of Transform alphabet keys to their names."
  value       = { for k, v in vault_transform_alphabet.this : k => v.name }
}

output "saml_auth_backends" {
  description = "Map of SAML auth backend keys to their paths."
  value       = { for k, v in vault_saml_auth_backend.this : k => v.path }
}

output "spiffe_auth_backends" {
  description = "Map of SPIFFE auth backend keys to their paths."
  value       = { for k, v in vault_auth_backend.spiffe : k => v.path }
}

output "oci_auth_backends" {
  description = "Map of OCI auth backend keys to their paths."
  value       = { for k, v in vault_auth_backend.oci : k => v.path }
}

output "alicloud_auth_backends" {
  description = "Map of AliCloud auth backend keys to their paths."
  value       = { for k, v in vault_auth_backend.alicloud : k => v.path }
}

###############################################################################
# Role outputs for new secret engines and auth backends
###############################################################################

output "consul_secret_roles" {
  description = "Map of Consul secret role keys to their names and backend paths."
  value = {
    for k, v in vault_consul_secret_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "nomad_secret_roles" {
  description = "Map of Nomad secret role keys to their role names and backend paths."
  value = {
    for k, v in vault_nomad_secret_role.this : k => {
      role    = v.role
      backend = v.backend
    }
  }
}

output "mongodbatlas_secret_roles" {
  description = "Map of MongoDB Atlas secret role keys to their names and mount paths."
  value = {
    for k, v in vault_mongodbatlas_secret_role.this : k => {
      name  = v.name
      mount = v.mount
    }
  }
}

output "rabbitmq_secret_roles" {
  description = "Map of RabbitMQ secret role keys to their names and backend paths."
  value = {
    for k, v in vault_rabbitmq_secret_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "terraform_cloud_secret_roles" {
  description = "Map of Terraform Cloud secret role keys to their names and backend paths."
  value = {
    for k, v in vault_terraform_cloud_secret_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "kmip_secret_roles" {
  description = "Map of KMIP secret role keys to their roles and paths."
  value = {
    for k, v in vault_kmip_secret_role.this : k => {
      role  = v.role
      path  = v.path
      scope = v.scope
    }
  }
}

output "kmip_secret_scopes" {
  description = "Map of KMIP secret scope keys to their scope names and paths."
  value = {
    for k, v in vault_kmip_secret_scope.this : k => {
      scope = v.scope
      path  = v.path
    }
  }
}

output "transform_roles" {
  description = "Map of Transform role keys to their names and paths."
  value = {
    for k, v in vault_transform_role.this : k => {
      name = v.name
      path = v.path
    }
  }
}

output "saml_auth_roles" {
  description = "Map of SAML auth role keys to their names and backend paths."
  value = {
    for k, v in vault_saml_auth_backend_role.this : k => {
      name = v.name
      path = v.path
    }
  }
}

output "spiffe_auth_roles" {
  description = "Map of SPIFFE auth role keys to their names and mount paths."
  value = {
    for k, v in vault_spiffe_auth_backend_role.this : k => {
      name  = v.name
      mount = v.mount
    }
  }
}

output "oci_auth_roles" {
  description = "Map of OCI auth role keys to their names and backend paths."
  value = {
    for k, v in vault_oci_auth_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "alicloud_auth_roles" {
  description = "Map of AliCloud auth role keys to their role names and backend paths."
  value = {
    for k, v in vault_alicloud_auth_backend_role.this : k => {
      role    = v.role
      backend = v.backend
    }
  }
}

###############################################################################
# Auth Backend Roles (remaining)
###############################################################################

output "aws_auth_roles" {
  description = "Map of AWS auth role keys to their role names and backend paths."
  value = {
    for k, v in vault_aws_auth_backend_role.this : k => {
      role    = v.role
      backend = v.backend
    }
  }
}

output "azure_auth_backends" {
  description = "Map of Azure auth backend keys to their paths."
  value       = { for k, v in vault_auth_backend.azure : k => v.path }
}

output "azure_auth_roles" {
  description = "Map of Azure auth role keys to their role names and backend paths."
  value = {
    for k, v in vault_azure_auth_backend_role.this : k => {
      role    = v.role
      backend = v.backend
    }
  }
}

output "gcp_auth_backends" {
  description = "Map of GCP auth backend keys to their paths."
  value       = { for k, v in vault_gcp_auth_backend.this : k => v.path }
}

output "gcp_auth_roles" {
  description = "Map of GCP auth role keys to their role names and backend paths."
  value = {
    for k, v in vault_gcp_auth_backend_role.this : k => {
      role    = v.role
      backend = v.backend
    }
  }
}

output "ldap_auth_backends" {
  description = "Map of LDAP auth backend keys to their paths."
  value       = { for k, v in vault_ldap_auth_backend.this : k => v.path }
}

output "ldap_auth_groups" {
  description = "Map of LDAP auth group keys to their group names and backend paths."
  value = {
    for k, v in vault_ldap_auth_backend_group.this : k => {
      groupname = v.groupname
      backend   = v.backend
    }
  }
}

output "ldap_secret_backend_static_roles" {
  description = "Map of LDAP secret static role keys to their role names and mount paths."
  value = {
    for k, v in vault_ldap_secret_backend_static_role.this : k => {
      role_name = v.role_name
      mount     = v.mount
    }
  }
}

output "ldap_secret_backend_library_sets" {
  description = "Map of LDAP secret library set keys to their names and mount paths."
  value = {
    for k, v in vault_ldap_secret_backend_library_set.this : k => {
      name  = v.name
      mount = v.mount
    }
  }
}

output "cert_auth_roles" {
  description = "Map of Cert auth role keys to their names and backend paths."
  value = {
    for k, v in vault_cert_auth_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "okta_auth_backends" {
  description = "Map of Okta auth backend keys to their paths and organizations."
  value = {
    for k, v in vault_okta_auth_backend.this : k => {
      path         = v.path
      organization = v.organization
    }
  }
}

output "okta_auth_groups" {
  description = "Map of Okta auth group keys to their group names and backend paths."
  value = {
    for k, v in vault_okta_auth_backend_group.this : k => {
      group_name = v.group_name
      path       = v.path
    }
  }
}

output "okta_auth_users" {
  description = "Map of Okta auth user keys to their usernames and backend paths."
  value = {
    for k, v in vault_okta_auth_backend_user.this : k => {
      username = v.username
      path     = v.path
    }
  }
}

output "token_auth_backend_roles" {
  description = "Map of Token auth role keys to their role names."
  value = {
    for k, v in vault_token_auth_backend_role.this : k => {
      role_name = v.role_name
    }
  }
}

output "ssh_roles" {
  description = "Map of SSH role keys to their names and backend paths."
  value = {
    for k, v in vault_ssh_secret_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

###############################################################################
# Identity OIDC
###############################################################################

output "identity_oidc_assignments" {
  description = "Map of Identity OIDC assignment keys to their names."
  value       = { for k, v in vault_identity_oidc_assignment.this : k => v.name }
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

output "identity_oidc_keys" {
  description = "Map of Identity OIDC key keys to their names."
  value       = { for k, v in vault_identity_oidc_key.this : k => v.name }
}

output "identity_oidc_scopes" {
  description = "Map of Identity OIDC scope keys to their names."
  value       = { for k, v in vault_identity_oidc_scope.this : k => v.name }
}

output "identity_oidc_roles" {
  description = "Map of Identity OIDC role keys to their names."
  value       = { for k, v in vault_identity_oidc_role.this : k => v.name }
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
# GCP Secret Rolesets and Static Accounts
###############################################################################

output "gcp_secret_rolesets" {
  description = "Map of GCP secret roleset keys to their rolesets and backend paths."
  value = {
    for k, v in vault_gcp_secret_roleset.this : k => {
      roleset = v.roleset
      backend = v.backend
    }
  }
}

output "gcp_secret_static_accounts" {
  description = "Map of GCP secret static account keys to their static accounts and backend paths."
  value = {
    for k, v in vault_gcp_secret_static_account.this : k => {
      static_account = v.static_account
      backend        = v.backend
    }
  }
}

###############################################################################
# PKI ACME
###############################################################################

output "pki_secret_backend_config_acmes" {
  description = "Map of PKI ACME config keys to their backend paths."
  value       = { for k, v in vault_pki_secret_backend_config_acme.this : k => v.backend }
}

output "pki_secret_backend_acme_eabs" {
  description = "Map of PKI ACME EAB keys to their IDs and backend paths."
  value = {
    for k, v in vault_pki_secret_backend_acme_eab.this : k => {
      id      = v.id
      backend = v.directory
    }
  }
}

###############################################################################
# Secrets Sync Destinations
###############################################################################

output "secrets_sync_aws_destinations" {
  description = "Map of Secrets Sync AWS destination keys to their names."
  value       = { for k, v in vault_secrets_sync_aws_destination.this : k => v.name }
}

output "secrets_sync_azure_destinations" {
  description = "Map of Secrets Sync Azure destination keys to their names."
  value       = { for k, v in vault_secrets_sync_azure_destination.this : k => v.name }
}

output "secrets_sync_gcp_destinations" {
  description = "Map of Secrets Sync GCP destination keys to their names."
  value       = { for k, v in vault_secrets_sync_gcp_destination.this : k => v.name }
}

output "secrets_sync_gh_destinations" {
  description = "Map of Secrets Sync GitHub destination keys to their names."
  value       = { for k, v in vault_secrets_sync_gh_destination.this : k => v.name }
}

output "secrets_sync_associations" {
  description = "Map of Secrets Sync association keys to their mount paths and secret names."
  value = {
    for k, v in vault_secrets_sync_association.this : k => {
      mount       = v.mount
      secret_name = v.secret_name
    }
  }
}

###############################################################################
# Transform Templates and Transformations
###############################################################################

output "transform_templates" {
  description = "Map of Transform template keys to their names and paths."
  value = {
    for k, v in vault_transform_template.this : k => {
      name = v.name
      path = v.path
    }
  }
}

output "transform_transformations" {
  description = "Map of Transform transformation keys to their names and paths."
  value = {
    for k, v in vault_transform_transformation.this : k => {
      name = v.name
      path = v.path
    }
  }
}
