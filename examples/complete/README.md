# Complete Example

This example demonstrates every feature supported by the `terraform-vault-module`. It serves as a reference implementation that exercises all available variables across secret engines, auth backends, identity, quotas, sync, and enterprise features.

## Architecture Overview

```
Vault
├── Namespaces (Enterprise)
├── Secret Engine Mounts
│   ├── KV-V2
│   ├── Transit
│   ├── PKI
│   ├── Database
│   ├── AWS / Azure / GCP
│   ├── LDAP (supersedes AD)
│   ├── Consul / Nomad
│   ├── MongoDB Atlas / RabbitMQ / Terraform Cloud
│   ├── KMIP (Enterprise)
│   └── Transform (Enterprise)
├── Auth Backends
│   ├── AppRole / UserPass / Token / GitHub
│   ├── Kubernetes
│   ├── JWT / OIDC
│   ├── AWS / Azure / GCP
│   ├── LDAP / Okta / Cert
│   └── LDAP
├── Policies
├── Audit Devices & Audit Headers
├── Identity (Entities, Groups, Aliases, OIDC, MFA)
├── Secrets Sync (Enterprise)
│   ├── AWS Secrets Manager
│   ├── Azure Key Vault
│   ├── GCP Secret Manager
│   └── GitHub Actions
├── Resource Quotas
│   ├── Rate Limits
│   └── Lease Counts
└── PKI ACME Support
```

## Features Demonstrated

| Category               | Features                                                                                                           |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------ |
| **Core**               | Mounts, Policies, Audit Devices, Generic Endpoints                                                                 |
| **Auth**               | AppRole, UserPass, Kubernetes, JWT/OIDC, GitHub, AWS, Azure, GCP, LDAP, Okta, Cert, Token                          |
| **Secrets**            | KV-V2, Transit, PKI, Database, AWS, SSH, Azure, GCP, LDAP, Consul, Nomad, MongoDB Atlas, RabbitMQ, Terraform Cloud |
| **Enterprise Secrets** | KMIP, Transform (FPE, masking, tokenization)                                                                       |
| **Identity**           | Entities, Groups, Aliases, OIDC Keys/Clients/Scopes/Providers/Roles, MFA (TOTP, Okta, Duo, PingID)                 |
| **Secrets Sync**       | AWS, Azure, GCP, GitHub destinations                                                                               |
| **Quotas**             | Rate limit quotas, Lease count quotas                                                                              |
| **PKI ACME**           | ACME configuration and EAB tokens                                                                                  |
| **Namespaces**         | Hierarchical namespace management (Enterprise)                                                                     |
| **Password Policies**  | Custom password generation rules                                                                                   |

## Usage

```hcl
module "vault" {
  source  = "atlet99/vault/module"
  version = "~> 1.0"

  ###########################################################################
  # Namespaces (Enterprise)
  ###########################################################################

  namespaces = {
    engineering = {
      path      = "engineering"
      namespace = null
    }
    platform = {
      path      = "platform"
      namespace = null
    }
  }

  ###########################################################################
  # Secret Engine Mounts
  ###########################################################################

  mounts = {
    kv = {
      path        = "secret"
      type        = "kv"
      description = "KV Version 2 secret engine"
      options     = { version = "2" }
    }
    transit = {
      path        = "transit"
      type        = "transit"
      description = "Transit encryption engine"
    }
    pki = {
      path                  = "pki"
      type                  = "pki"
      description           = "PKI secrets engine"
      max_lease_ttl_seconds = 315360000
    }
    database = {
      path        = "database"
      type        = "database"
      description = "Database secrets engine"
    }
  }

  ###########################################################################
  # Policies
  ###########################################################################

  policies = {
    admin = {
      name   = "admin"
      policy = <<-EOT
        path "*" {
          capabilities = ["create", "read", "update", "delete", "list", "sudo"]
        }
      EOT
    }
    readonly = {
      name   = "readonly"
      policy = <<-EOT
        path "secret/data/*" {
          capabilities = ["read", "list"]
        }
      EOT
    }
  }

  ###########################################################################
  # Password Policies
  ###########################################################################

  password_policies = {
    complex = {
      name   = "complex-policy"
      policy = <<-EOT
        length = 24
        rule "charset" {
          charset   = "abcdefghijklmnopqrstuvwxyz"
          min-chars = 1
        }
        rule "charset" {
          charset   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
          min-chars = 1
        }
        rule "charset" {
          charset   = "0123456789"
          min-chars = 1
        }
        rule "charset" {
          charset   = "!@#$%^&*()-_=+"
          min-chars = 1
        }
      EOT
    }
  }

  ###########################################################################
  # Audit
  ###########################################################################

  audit_devices = {
    file = {
      type        = "file"
      description = "File audit log"
      options     = { file_path = "/vault/logs/audit.log" }
    }
  }

  audit_request_headers = {
    x_forwarded_for = {
      name = "X-Forwarded-For"
      hmac = false
    }
  }

  ###########################################################################
  # Generic Endpoints
  ###########################################################################

  generic_endpoints = {
    sys_message = {
      path = "sys/config/ui/custom-message"
      data_json = jsonencode({
        help_message = "Welcome to Vault!"
      })
    }
  }

  ###########################################################################
  # Auth Backends
  ###########################################################################

  auth_backends = {
    approle = {
      type        = "approle"
      description = "AppRole auth backend"
    }
    userpass = {
      type        = "userpass"
      description = "Username/Password auth backend"
      tune = {
        default_lease_ttl = "1h"
        max_lease_ttl     = "24h"
      }
    }
    github = {
      type        = "github"
      description = "GitHub auth backend"
    }
  }

  approle_auth_roles = {
    app = {
      role_name      = "app-role"
      token_policies = ["readonly"]
      token_ttl      = 3600
    }
  }

  jwt_oidc_auth_roles = {
    oidc = {
      role_name             = "oidc-role"
      role_type             = "oidc"
      bound_audiences       = ["vault-client-id"]
      user_claim            = "sub"
      token_policies        = ["readonly"]
      allowed_redirect_uris = ["https://vault.example.com/ui/vault/auth/oidc/oidc/callback"]
    }
  }

  github_auth_backends = {
    main = {
      path         = "github"
      organization = "my-org"
    }
  }

  token_auth_backend_roles = {
    utility = {
      role_name        = "utility-token"
      allowed_policies = ["readonly"]
      orphan           = true
      renewable        = true
      token_ttl        = 3600
    }
  }

  ###########################################################################
  # Kubernetes Auth
  ###########################################################################

  kubernetes_auth_backends = {
    primary = {
      path                   = "kubernetes"
      description            = "Kubernetes cluster auth"
      kubernetes_host        = "https://kubernetes.default.svc"
      disable_iss_validation = true
      roles = {
        app = {
          role_name                        = "app"
          bound_service_account_names      = ["app-sa"]
          bound_service_account_namespaces = ["default", "app"]
          token_policies                   = ["readonly"]
          token_ttl                        = 3600
        }
      }
    }
  }

  ###########################################################################
  # AWS / Azure / GCP Auth
  ###########################################################################

  aws_auth_backends = {
    prod = {
      path        = "aws"
      description = "AWS auth backend"
    }
  }

  aws_auth_roles = {
    iam = {
      role                     = "iam-role"
      backend                  = "aws"
      auth_type                = "iam"
      bound_iam_principal_arns = ["arn:aws:iam::123456789012:role/MyRole"]
      resolve_aws_unique_ids   = false
      token_policies           = ["readonly"]
    }
  }

  azure_auth_backends = {
    prod = {
      path      = "azure"
      tenant_id = "00000000-0000-0000-0000-000000000000"
      resource  = "https://management.azure.com/"
    }
  }

  azure_auth_roles = {
    dev = {
      role                   = "dev-role"
      backend                = "azure"
      bound_subscription_ids = ["00000000-0000-0000-0000-000000000000"]
      bound_resource_groups  = ["rg-dev"]
      token_policies         = ["readonly"]
    }
  }

  gcp_auth_backends = {
    prod = {
      path        = "gcp"
      description = "GCP auth backend"
    }
  }

  gcp_auth_roles = {
    compute = {
      role           = "compute-role"
      backend        = "gcp"
      type           = "gce"
      bound_projects = ["my-gcp-project"]
      token_policies = ["readonly"]
    }
  }

  ###########################################################################
  # LDAP / Okta / Cert Auth
  ###########################################################################

  ldap_auth_backends = {
    corp = {
      path      = "ldap"
      url       = "ldaps://ldap.example.com"
      userdn    = "ou=Users,dc=example,dc=com"
      userattr  = "uid"
      groupdn   = "ou=Groups,dc=example,dc=com"
      groupattr = "cn"
    }
  }

  ldap_auth_groups = {
    engineering = {
      groupname = "engineering"
      backend   = "ldap"
      policies  = ["readonly"]
    }
  }

  okta_auth_backends = {
    corp = {
      path         = "okta"
      organization = "my-org"
      base_url     = "okta.com"
    }
  }

  okta_auth_groups = {
    devs = {
      group_name = "developers"
      path       = "okta"
      policies   = ["readonly"]
    }
  }

  okta_auth_users = {
    john = {
      username = "john.doe"
      path     = "okta"
      groups   = ["developers"]
    }
  }

  cert_auth_backends = {
    prod = {
      path        = "cert"
      description = "TLS Certificate auth"
    }
  }

  cert_auth_roles = {
    web = {
      name           = "web-servers"
      backend        = "cert"
      certificate    = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
      allowed_names  = ["web-*.example.com"]
      token_policies = ["readonly"]
    }
  }

  ###########################################################################
  # KV-V2 Secrets
  ###########################################################################

  kv_secret_backend_v2_config = {
    secret = {
      mount        = "secret"
      max_versions = 10
      cas_required = false
    }
  }

  kv_secrets_v2 = {
    app_config = {
      mount     = "secret"
      name      = "app/config"
      data_json = jsonencode({ db_host = "db.example.com", db_port = "5432" })
    }
  }

  ###########################################################################
  # Transit Keys
  ###########################################################################

  transit_keys = {
    app_key = {
      name             = "app-key"
      backend          = "transit"
      type             = "aes256-gcm96"
      deletion_allowed = true
    }
  }

  ###########################################################################
  # Database Secret Engine
  ###########################################################################

  database_connections = {
    postgres = {
      name          = "postgres"
      backend       = "database"
      allowed_roles = ["readonly", "app-user"]
      postgresql = {
        connection_url = "postgresql://{{username}}:{{password}}@localhost:5432/postgres"
      }
    }
  }

  database_roles = {
    readonly = {
      name                = "readonly"
      backend             = "database"
      db_name             = "postgres"
      creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"]
    }
  }

  database_static_roles = {
    app_user = {
      name            = "app-user"
      backend         = "database"
      db_name         = "postgres"
      username        = "app_service"
      rotation_period = 86400
    }
  }

  ###########################################################################
  # PKI Secret Engine
  ###########################################################################

  pki_roles = {
    internal_tls = {
      name             = "internal-tls"
      backend          = "pki"
      allow_subdomains = true
      allowed_domains  = ["internal.example.com"]
      ttl              = "24h"
    }
  }

  pki_secret_backend_config_acmes = {
    main = {
      backend                  = "pki"
      enabled                  = true
      default_directory_policy = "sign-verbatim"
    }
  }

  ###########################################################################
  # AWS Secret Engine
  ###########################################################################

  aws_roles = {
    lambda = {
      name            = "lambda-role"
      backend         = "aws"
      credential_type = "iam_user"
      policy_arns     = ["arn:aws:iam::aws:policy/AmazonSQSFullAccess"]
    }
  }

  ###########################################################################
  # SSH Secret Engine
  ###########################################################################

  ssh_roles = {
    ca = {
      name                    = "ca-role"
      backend                 = "ssh"
      key_type                = "ca"
      allow_user_certificates = true
      allowed_users           = "ubuntu,admin"
      ttl                     = "1h"
    }
  }

  ###########################################################################
  # Azure Secret Engine
  ###########################################################################

  azure_secret_backends = {
    main = {
      path            = "azure"
      subscription_id = "00000000-0000-0000-0000-000000000000"
      tenant_id       = "00000000-0000-0000-0000-000000000000"
    }
  }

  azure_secret_backend_roles = {
    dev = {
      role    = "dev-role"
      backend = "azure"
      azure_roles = [
        { role_name = "Contributor", scope = "/subscriptions/00000000-0000-0000-0000-000000000000" }
      ]
      ttl     = "1h"
      max_ttl = "4h"
    }
  }

  ###########################################################################
  # GCP Secret Engine
  ###########################################################################

  gcp_secret_backends = {
    main = {
      path        = "gcp"
      description = "GCP secret backend"
    }
  }

  ###########################################################################
  # LDAP Secret Engine
  ###########################################################################

  ldap_secret_backends = {
    corp = {
      path   = "ldap"
      binddn = "cn=vault,dc=example,dc=com"
      url    = "ldaps://ldap.example.com"
    }
  }

  ldap_secret_backend_static_roles = {
    svc_account = {
      role_name       = "svc-account"
      mount           = "ldap"
      username        = "svc-vault"
      rotation_period = 86400
    }
  }

  ###########################################################################
  # Consul Secret Engine
  ###########################################################################

  consul_secret_backends = {
    main = {
      path    = "consul"
      address = "consul.example.com:8500"
      token   = "root-token"
    }
  }

  consul_secret_roles = {
    ops = {
      name     = "ops-role"
      backend  = "consul"
      policies = ["global-management"]
      ttl      = 3600
    }
  }

  ###########################################################################
  # Nomad Secret Engine
  ###########################################################################

  nomad_secret_backends = {
    main = {
      path    = "nomad"
      address = "http://nomad.example.com:4646"
      token   = "root-token"
    }
  }

  nomad_secret_roles = {
    ops = {
      role     = "ops-role"
      backend  = "nomad"
      policies = ["global-management"]
      global   = true
      type     = "client"
    }
  }

  ###########################################################################
  # MongoDB Atlas Secret Engine
  ###########################################################################

  mongodbatlas_secret_backends = {
    main = {
      path        = "mongodbatlas"
      private_key = "00000000-0000-0000-0000-000000000000"
      public_key  = "abcdefgh"
    }
  }

  mongodbatlas_secret_roles = {
    readonly = {
      name       = "readonly"
      mount      = "mongodbatlas"
      project_id = "5cf5a45a9ccf6400e60981b6"
      roles      = ["GROUP_READ_ONLY"]
      ttl        = "1h"
      max_ttl    = "4h"
    }
  }

  ###########################################################################
  # RabbitMQ Secret Engine
  ###########################################################################

  rabbitmq_secret_backends = {
    main = {
      path           = "rabbitmq"
      connection_uri = "http://rabbitmq.example.com:15672"
      username       = "vault"
      password       = "rabbitmq-password"
    }
  }

  rabbitmq_secret_roles = {
    deploy = {
      name    = "deploy"
      backend = "rabbitmq"
      tags    = "policymaker,management"
      vhost   = { "/" = { configure = ".*", read = ".*", write = ".*" } }
    }
  }

  ###########################################################################
  # Terraform Cloud Secret Engine
  ###########################################################################

  terraform_cloud_secret_backends = {
    main = {
      path  = "terraform"
      token = "TFC-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    }
  }

  terraform_cloud_secret_roles = {
    ops = {
      name         = "ops-role"
      backend      = "terraform"
      organization = "my-tfc-org"
      ttl          = 3600
      max_ttl      = 86400
    }
  }

  ###########################################################################
  # KMIP Secret Engine (Enterprise only)
  ###########################################################################

  kmip_secret_backends = {
    main = {
      path             = "kmip"
      description      = "KMIP backend for external key management"
      server_hostnames = ["kmip.example.com"]
      tls_min_version  = "tls12"
    }
  }

  kmip_secret_scopes = {
    dev = {
      scope = "dev"
      path  = "kmip"
      force = true
    }
  }

  kmip_secret_roles = {
    admin = {
      role                    = "admin"
      path                    = "kmip"
      scope                   = "dev"
      tls_client_key_type     = "ec"
      tls_client_key_bits     = 256
      operation_activate      = true
      operation_create        = true
      operation_get           = true
      operation_get_attributes = true
      operation_destroy       = true
    }
  }

  ###########################################################################
  # Transform Secret Engine (Enterprise only)
  ###########################################################################

  transform_alphabets = {
    numeric = {
      name     = "numeric"
      path     = "transform"
      alphabet = "0123456789"
    }
  }

  transform_templates = {
    ssn = {
      name    = "ssn"
      path    = "transform"
      type    = "regex"
      pattern = "(\\d{3})-(\\d{2})-(\\d{4})"
      alphabet = "numeric"
    }
  }

  transform_transformations = {
    card_num = {
      name          = "card-number"
      path          = "transform"
      type          = "fpe"
      template      = "ssn"
      tweak_source  = "internal"
      allowed_roles = ["payments"]
    }
  }

  transform_roles = {
    payments = {
      name            = "payments"
      path            = "transform"
      transformations = ["card-number"]
    }
  }

  ###########################################################################
  # Identity
  ###########################################################################

  identity_entities = {
    john_doe = {
      name     = "john-doe"
      metadata = { team = "platform" }
      policies = ["readonly"]
    }
  }

  identity_groups = {
    platform = {
      name     = "platform-team"
      policies = ["admin"]
    }
  }

  identity_group_memberships = {
    john_in_platform = {
      group_id   = "platform"
      member_ids = []
    }
  }

  identity_oidc_keys = {
    default = {
      name             = "default-key"
      algorithm        = "RS256"
      verification_ttl = 86400
      rotation_period  = 86400
    }
  }

  identity_oidc_clients = {
    web_app = {
      name          = "web-app"
      key           = "default-key"
      redirect_uris = ["https://app.example.com/callback"]
      client_type   = "confidential"
    }
  }

  identity_oidc_scopes = {
    profile = {
      name        = "profile"
      description = "User profile scope"
      template    = jsonencode({ username = "{{identity.entity.name}}" })
    }
  }

  identity_oidc_providers = {
    main = {
      name             = "main"
      issuer_host      = "vault.example.com"
      https_enabled    = true
      scopes_supported = ["profile"]
    }
  }

  identity_oidc_assignments = {
    all_entities = {
      name       = "all-entities"
      entity_ids = ["*"]
    }
  }

  identity_oidc_roles = {
    web_app = {
      name      = "web-app-role"
      key       = "default-key"
      ttl       = 86400
    }
  }

  identity_mfa_totp = {
    google_auth = {
      issuer  = "Vault-Example"
      digits  = 6
      qr_size = 200
      period  = 30
    }
  }

  identity_mfa_okta = {
    corp = {
      name           = "okta-mfa"
      mount_accessor = "auth_okta_xxxxxxxx"
      org_name       = "my-org"
      api_token      = "okta-api-token"
    }
  }

  identity_mfa_duo = {
    corp = {
      name            = "duo-mfa"
      mount_accessor  = "auth_userpass_xxxxxxxx"
      secret_key      = "duo-secret-key"
      integration_key = "duo-integration-key"
      api_hostname    = "api-xxxxx.duosecurity.com"
    }
  }

  ###########################################################################
  # Secrets Sync (Enterprise)
  ###########################################################################

  secrets_sync_config = {
    disabled       = false
    queue_capacity = 1000
  }

  secrets_sync_aws_destinations = {
    prod = {
      name                 = "aws-prod"
      region               = "us-east-1"
      role_arn             = "arn:aws:iam::123456789012:role/VaultSync"
      secret_name_template = "vault/{{.MountAccessor}}/{{.SecretPath}}"
      granularity          = "secret-key"
    }
  }

  secrets_sync_azure_destinations = {
    prod = {
      name          = "azure-prod"
      tenant_id     = "00000000-0000-0000-0000-000000000000"
      key_vault_uri = "https://my-vault.vault.azure.net/"
      granularity   = "secret-key"
    }
  }

  secrets_sync_gcp_destinations = {
    prod = {
      name       = "gcp-prod"
      project_id = "my-gcp-project"
      granularity = "secret-key"
    }
  }

  secrets_sync_gh_destinations = {
    actions = {
      name             = "gh-actions"
      repository_owner = "my-org"
      repository_name  = "my-repo"
      granularity      = "secret-key"
    }
  }

  ###########################################################################
  # Resource Quotas
  ###########################################################################

  quota_rate_limits = {
    global = {
      name     = "global-rate-limit"
      rate     = 100
      interval = 1
    }
  }

  quota_lease_counts = {
    global = {
      name       = "global-lease-count"
      max_leases = 10000
    }
  }
}

###############################################################################
# Outputs
###############################################################################

output "mount_paths" {
  value = module.vault.mount_paths
}

output "auth_backend_paths" {
  value = module.vault.auth_backend_paths
}

output "policy_names" {
  value = module.vault.policy_names
}

output "consul_secret_backends" {
  value = module.vault.consul_secret_backends
}

output "nomad_secret_backends" {
  value = module.vault.nomad_secret_backends
}

output "terraform_cloud_secret_backends" {
  value = module.vault.terraform_cloud_secret_backends
}

output "kmip_secret_backends" {
  value = module.vault.kmip_secret_backends
}
```

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.11.0 |
| vault     | >= 5.7.0  |

## Providers

No providers are configured directly in this example — all resources are managed through the root module.

## Notes

- **Enterprise features**: `kmip_secret_backends`, `transform_*`, `namespaces`, `secrets_sync_*`, and `identity_mfa_okta`/`duo`/`pingid` require **Vault Enterprise**.
- **Sensitive values**: Tokens, credentials, and private keys shown here are placeholders — use environment variables or a secrets manager in production.
- **Source address**: In production, reference the published registry address (`atlet99/vault/module`) rather than a local relative path.
