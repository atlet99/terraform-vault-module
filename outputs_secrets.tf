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
# Database Secret Backend
###############################################################################

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

###############################################################################
# PKI Secret Backend
###############################################################################

output "pki_roles" {
  description = "Map of PKI role keys to their names and backend paths."
  value = {
    for k, v in vault_pki_secret_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

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

output "pki_backend_config_cas" {
  description = "Map of PKI backend CA config keys to their backend paths."
  value       = { for k, v in vault_pki_secret_backend_config_ca.this : k => v.backend }
}

output "pki_backend_root_certs" {
  description = "Map of PKI root certificate keys to their certificate details."
  value = {
    for k, v in vault_pki_secret_backend_root_cert.this : k => {
      certificate   = v.certificate
      issuing_ca    = v.issuing_ca
      serial_number = v.serial_number
      issuer_id     = v.issuer_id
    }
  }
}

output "pki_backend_intermediate_cert_requests" {
  description = "Map of PKI intermediate CSR keys to their CSR details."
  value = {
    for k, v in vault_pki_secret_backend_intermediate_cert_request.this : k => {
      csr = v.csr
    }
  }
}

output "pki_backend_intermediate_set_signeds" {
  description = "Map of signed intermediate cert keys to their imported status."
  value = {
    for k, v in vault_pki_secret_backend_intermediate_set_signed.this : k => {
      imported_issuers = v.imported_issuers
      imported_keys    = v.imported_keys
    }
  }
}

output "pki_backend_config_auto_tidies" {
  description = "Map of PKI auto-tidy keys to their backend paths."
  value       = { for k, v in vault_pki_secret_backend_config_auto_tidy.this : k => v.backend }
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

output "aws_static_roles" {
  description = "Map of AWS static role keys to their names and backend paths."
  value = {
    for k, v in vault_aws_secret_backend_static_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

###############################################################################
# SSH Secret Backend
###############################################################################

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
# Azure Secret Backend
###############################################################################

output "azure_secret_backends" {
  description = "Map of Azure secret backend keys to their paths."
  value       = { for k, v in vault_azure_secret_backend.this : k => v.path }
}

output "azure_secret_backend_roles" {
  description = "Map of Azure secret backend role keys to their role names and backend paths."
  value = {
    for k, v in vault_azure_secret_backend_role.this : k => {
      role    = v.role
      backend = v.backend
    }
  }
}

output "azure_static_roles" {
  description = "Map of Azure static role keys to their role names and backend paths."
  value = {
    for k, v in vault_azure_secret_backend_static_role.this : k => {
      role    = v.role
      backend = v.backend
    }
  }
}

###############################################################################
# GCP Secret Backend
###############################################################################

output "gcp_secret_backends" {
  description = "Map of GCP secret backend keys to their paths."
  value       = { for k, v in vault_gcp_secret_backend.this : k => v.path }
}

output "gcp_secret_backend_rolesets" {
  description = "Map of GCP secret roleset keys to their rolesets and backend paths."
  value = {
    for k, v in vault_gcp_secret_roleset.this : k => {
      roleset = v.roleset
      backend = v.backend
    }
  }
}

output "gcp_secret_backend_static_accounts" {
  description = "Map of GCP secret static account keys to their static accounts and backend paths."
  value = {
    for k, v in vault_gcp_secret_static_account.this : k => {
      static_account = v.static_account
      backend        = v.backend
    }
  }
}

###############################################################################
# LDAP Secret Backend
###############################################################################

output "ldap_secret_backends" {
  description = "Map of LDAP secret backend keys to their paths."
  value       = { for k, v in vault_ldap_secret_backend.this : k => v.path }
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

###############################################################################
# Consul, Nomad, MongoDB Atlas, RabbitMQ, Terraform Cloud
###############################################################################

output "consul_secret_backends" {
  description = "Map of Consul secret backend keys to their paths."
  value       = { for k, v in vault_consul_secret_backend.this : k => v.path }
}

output "consul_secret_roles" {
  description = "Map of Consul secret role keys to their names and backend paths."
  value = {
    for k, v in vault_consul_secret_backend_role.this : k => {
      name    = v.name
      backend = v.backend
    }
  }
}

output "nomad_secret_backends" {
  description = "Map of Nomad secret backend keys to their paths."
  value       = { for k, v in vault_nomad_secret_backend.this : k => v.backend }
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

output "mongodbatlas_secret_backends" {
  description = "Map of MongoDB Atlas secret backend keys to their mount paths."
  value       = { for k, v in vault_mongodbatlas_secret_backend.this : k => v.mount }
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

output "rabbitmq_secret_backends" {
  description = "Map of RabbitMQ secret backend keys to their paths."
  value       = { for k, v in vault_rabbitmq_secret_backend.this : k => v.path }
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

output "terraform_cloud_secret_backends" {
  description = "Map of Terraform Cloud secret backend keys to their paths."
  value       = { for k, v in vault_terraform_cloud_secret_backend.this : k => v.backend }
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

###############################################################################
# KMIP Secret Backend (Enterprise)
###############################################################################

output "kmip_secret_backends" {
  description = "Map of KMIP secret backend keys to their paths."
  value       = { for k, v in vault_kmip_secret_backend.this : k => v.path }
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

###############################################################################
# Transform Secret Backend (Enterprise)
###############################################################################

output "transform_alphabets" {
  description = "Map of Transform alphabet keys to their names."
  value       = { for k, v in vault_transform_alphabet.this : k => v.name }
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

output "kv_secrets" {
  description = "Map of KV-V1 secret keys to their paths."
  value       = { for k, v in vault_kv_secret.this : k => v.path }
}

###############################################################################
# Managed Keys
###############################################################################

output "managed_keys" {
  description = "The ID of the Managed Keys resource."
  value       = var.managed_keys != null ? vault_managed_keys.this[0].id : null
}
