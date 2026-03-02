###############################################################################
# Complete Example
# Demonstrates all resource types supported by the module.
###############################################################################

module "vault" {
  source = "../../"

  # -- Secrets Engine Mounts --------------------------------------------------

  mounts = {
    kv = {
      path           = "secret"
      type           = "kv"
      description    = "KV Version 2 secret engine"
      options        = { version = "2" }
      force_no_cache = true
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
      max_lease_ttl_seconds = 315360000 # 10 years
    }
  }

  # -- Auth Backends -----------------------------------------------------------

  auth_backends = {
    approle = {
      type        = "approle"
      description = "AppRole auth"
    }

    userpass = {
      type        = "userpass"
      description = "Username/Password auth"
      tune = {
        default_lease_ttl = "1h"
        max_lease_ttl     = "24h"
      }
    }
  }

  # -- Policies ----------------------------------------------------------------

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

    app_team = {
      name   = "app-team"
      policy = <<-EOT
        path "secret/data/app/*" {
          capabilities = ["create", "read", "update", "list"]
        }
        path "transit/encrypt/app-key" {
          capabilities = ["update"]
        }
        path "transit/decrypt/app-key" {
          capabilities = ["update"]
        }
      EOT
    }
  }

  # -- Audit Devices -----------------------------------------------------------

  audit_devices = {
    file = {
      type        = "file"
      description = "File audit device"
      options = {
        file_path = "/vault/logs/audit.log"
      }
    }
  }

  # -- Kubernetes Auth ---------------------------------------------------------

  kubernetes_auth_backends = {
    primary = {
      path                   = "kubernetes"
      description            = "Primary K8s cluster auth"
      kubernetes_host        = "https://kubernetes.default.svc"
      disable_iss_validation = true

      roles = {
        app = {
          role_name                        = "app"
          bound_service_account_names      = ["app-sa"]
          bound_service_account_namespaces = ["default", "app"]
          token_policies                   = ["app-team"]
          token_ttl                        = 3600
          token_max_ttl                    = 86400
        }

        monitoring = {
          role_name                        = "monitoring"
          bound_service_account_names      = ["prometheus-sa"]
          bound_service_account_namespaces = ["monitoring"]
          token_policies                   = ["readonly"]
          token_ttl                        = 1800
        }
      }
    }
  }

  # -- KV-V2 Backend Config ----------------------------------------------------

  kv_secret_backend_v2_config = {
    secret = {
      mount        = "secret"
      max_versions = 10
      cas_required = false
    }
  }

  # -- KV-V2 Secrets ----------------------------------------------------------

  kv_secrets_v2 = {
    app_config = {
      mount = "secret"
      name  = "app/config"
      data_json = jsonencode({
        db_host = "db.example.com"
        db_port = "5432"
      })
    }
  }

  # -- Generic Endpoints -------------------------------------------------------

  generic_endpoints = {
    # Custom configuration example
    sys_config = {
      path = "sys/config/ui/custom-message"
      data_json = jsonencode({
        help_message = "Welcome to Vault!"
      })
    }
  }

  # -- AppRole Auth Roles ----------------------------------------------------

  approle_auth_roles = {
    app_role = {
      role_name      = "app-role"
      token_policies = ["app_team"]
      token_ttl      = 3600
    }
  }

  # -- JWT/OIDC Auth Roles ---------------------------------------------------

  jwt_oidc_auth_roles = {
    oidc_role = {
      role_name             = "oidc-role"
      role_type             = "oidc"
      bound_audiences       = ["vault-client-id"]
      user_claim            = "sub"
      token_policies        = ["readonly"]
      allowed_redirect_uris = ["http://localhost:8200/ui/vault/auth/oidc/oidc/callback"]
    }
  }

  # -- Transit Keys ----------------------------------------------------------

  transit_keys = {
    app_key = {
      name             = "app-key-v2"
      backend          = "transit"
      type             = "aes256-gcm96"
      deletion_allowed = true
    }
  }

  # -- Password Policies -----------------------------------------------------

  password_policies = {
    complex = {
      name   = "complex-policy"
      policy = <<-EOT
        length = 24
        rule "charset" {
          charset = "abcdefghijklmnopqrstuvwxyz"
          min-chars = 1
        }
        rule "charset" {
          charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
          min-chars = 1
        }
        rule "charset" {
          charset = "0123456789"
          min-chars = 1
        }
        rule "charset" {
          charset = "!@#$%^&*()-_=+"
          min-chars = 1
        }
      EOT
    }
  }

  # -- Database Connections (Phase 3) -----------------------------------------

  database_connections = {
    postgres = {
      name    = "postgres"
      backend = "database"
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

  # -- PKI Roles (Phase 3) ----------------------------------------------------

  pki_roles = {
    internal_tls = {
      name             = "internal-tls"
      backend          = "pki"
      allow_subdomains = true
      allowed_domains  = ["internal.example.com"]
      ttl              = "24h"
    }
  }

  # -- AWS Roles (Phase 3) ----------------------------------------------------

  aws_roles = {
    lambda_sqs = {
      name            = "lambda-sqs"
      backend         = "aws"
      credential_type = "iam_user"
      policy_arns     = ["arn:aws:iam::aws:policy/AmazonSQSFullAccess"]
    }
  }

  # -- GitHub Auth (Phase 3) --------------------------------------------------

  github_auth_backends = {
    main = {
      path         = "github"
      organization = "example-org"
    }
  }

  # -- Identity Entities ------------------------------------------------------

  identity_entities = {
    john_doe = {
      name     = "john-doe"
      metadata = { team = "platform", role = "engineer" }
      policies = ["readonly"]
    }

    app_service = {
      name     = "app-service"
      metadata = { project = "billing" }
      policies = ["app_team"]
    }
  }

  # -- Identity Groups ---------------------------------------------------------

  identity_groups = {
    platform_team = {
      name     = "platform-team"
      metadata = { department = "infrastructure" }
      policies = ["admin"]
    }
  }

  # -- Identity Aliases --------------------------------------------------------
  # Note: Aliases link external identifiers to Vault entities/groups.
  # The mount_accessor can be obtained from the auth_backend outputs.

  identity_entity_aliases = {
    john_kubernetes = {
      name           = "john-doe-sa"
      mount_accessor = "auth_kubernetes_12345678" # Example accessor
      canonical_id   = "pending"                  # Replaced by entity ID in practice
    }
  }

  identity_group_aliases = {
    platform_kubernetes = {
      name           = "platform-team-sa"
      mount_accessor = "auth_kubernetes_12345678"
      canonical_id   = "pending"
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

output "kubernetes_auth_paths" {
  value = module.vault.kubernetes_auth_backend_paths
}

output "identity_entity_ids" {
  value = module.vault.identity_entity_ids
}

output "identity_group_ids" {
  value = module.vault.identity_group_ids
}

output "identity_entity_aliases" {
  value = module.vault.identity_entity_aliases
}

output "identity_group_aliases" {
  value = module.vault.identity_group_aliases
}

output "approle_auth_roles" {
  value = module.vault.approle_auth_roles
}

output "jwt_oidc_auth_roles" {
  value = module.vault.jwt_oidc_auth_roles
}

output "transit_keys" {
  value = module.vault.transit_keys
}

output "password_policies" {
  value = module.vault.password_policies
}

output "database_connections" {
  value = module.vault.database_connections
}

output "database_roles" {
  value = module.vault.database_roles
}

output "pki_roles" {
  value = module.vault.pki_roles
}

output "aws_roles" {
  value = module.vault.aws_roles
}

output "github_auth_backends" {
  value = module.vault.github_auth_backends
}
