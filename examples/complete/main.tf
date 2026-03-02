###############################################################################
# Complete Example
# Demonstrates all resource types supported by the module.
###############################################################################

module "vault" {
  source = "../../"

  # -- Secrets Engine Mounts --------------------------------------------------

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
    transit_key = {
      path = "transit/keys/app-key"
      data_json = jsonencode({
        type = "aes256-gcm96"
      })
      disable_read   = false
      disable_delete = true
    }
  }
  # -- Identity Entities ------------------------------------------------------

  identity_entities = {
    john_doe = {
      name     = "john-doe"
      metadata = { team = "platform", role = "engineer" }
      policies = ["readonly"]
    }

    app_servive = {
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
