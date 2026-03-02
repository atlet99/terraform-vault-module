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

output "kubernetes_auth_backend_configs" {
  description = "Map of Kubernetes auth backend config keys to their backend paths."
  value       = { for k, v in vault_kubernetes_auth_backend_config.this : k => v.backend }
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
# AppRole Auth
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
# JWT/OIDC Auth
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
# GitHub Auth
###############################################################################

output "github_auth_backends" {
  description = "Map of GitHub auth backend keys to their paths and organization."
  value = {
    for k, v in vault_github_auth_backend.this : k => {
      path         = v.path
      organization = v.organization
    }
  }
}

###############################################################################
# AWS Auth
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

output "aws_auth_backends" {
  description = "Map of AWS auth backend client keys to their backend paths."
  value       = { for k, v in vault_aws_auth_backend_client.this : k => v.backend }
}

###############################################################################
# Azure Auth
###############################################################################

output "azure_auth_backends" {
  description = "Map of Azure auth backend keys to their paths."
  value       = { for k, v in vault_auth_backend.azure : k => v.path }
}

output "azure_auth_backend_configs" {
  description = "Map of Azure auth backend config keys to their backend paths."
  value       = { for k, v in vault_azure_auth_backend_config.this : k => v.backend }
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

###############################################################################
# GCP Auth
###############################################################################

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

###############################################################################
# LDAP Auth
###############################################################################

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

###############################################################################
# Okta Auth
###############################################################################

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

###############################################################################
# Cert Auth
###############################################################################

output "cert_auth_roles" {
  description = "Map of Cert auth role keys to their names and backend paths."
  value = {
    for k, v in vault_cert_auth_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

###############################################################################
# Token Auth
###############################################################################

output "token_auth_backend_roles" {
  description = "Map of Token auth role keys to their role names."
  value = {
    for k, v in vault_token_auth_backend_role.this : k => {
      role_name = v.role_name
    }
  }
}

###############################################################################
# SAML, SPIFFE, OCI, AliCloud Auth
###############################################################################

output "saml_auth_backends" {
  description = "Map of SAML auth backend keys to their paths."
  value       = { for k, v in vault_saml_auth_backend.this : k => v.path }
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

output "spiffe_auth_backends" {
  description = "Map of SPIFFE auth backend keys to their paths."
  value       = { for k, v in vault_auth_backend.spiffe : k => v.path }
}

output "spiffe_auth_backend_configs" {
  description = "Map of SPIFFE auth backend config keys to their mount paths."
  value       = { for k, v in vault_spiffe_auth_backend_config.this : k => v.mount }
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

output "oci_auth_backends" {
  description = "Map of OCI auth backend keys to their paths."
  value       = { for k, v in vault_auth_backend.oci : k => v.path }
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

output "alicloud_auth_backends" {
  description = "Map of AliCloud auth backend keys to their paths."
  value       = { for k, v in vault_auth_backend.alicloud : k => v.path }
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
