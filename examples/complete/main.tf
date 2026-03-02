###############################################################################
# Complete Example - Main configuration hub
# Demonstrates all resource types supported by the module using split local blocks
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

  # -- Generic Endpoints -------------------------------------------------------
  generic_endpoints = {
    sys_config = {
      path = "sys/config/ui/custom-message"
      data_json = jsonencode({
        help_message = "Welcome to Vault!"
      })
    }
  }

  # -- Plugins -----------------------------------------------------------------
  plugins = {
    # Example plugin registration (requires the plugin binary to be present)
    # custom_plugin = {
    #   name    = "custom-plugin"
    #   type    = "secret"
    #   command = "custom-plugin"
    #   sha256  = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" # SHA256 of empty string for template
    # }
  }

  # Incorporate refactored variables
  kubernetes_auth_backends = local.kubernetes_auth_backends
  approle_auth_roles       = local.approle_auth_roles
  jwt_oidc_auth_roles      = local.jwt_oidc_auth_roles

  kv_secret_backend_v2_config = local.kv_secret_backend_v2_config
  kv_secrets_v2               = local.kv_secrets_v2
  kv_secrets                  = local.kv_secrets
  transit_keys                = local.transit_keys

  policies                   = local.policies
  identity_entities          = local.identity_entities
  identity_groups            = local.identity_groups
  identity_group_memberships = local.identity_group_memberships

  namespaces                       = local.namespaces
  raft_autopilot                   = local.raft_autopilot
  secrets_sync_vercel_destinations = local.secrets_sync_vercel_destinations
  secrets_sync_gh_destinations     = local.secrets_sync_gh_destinations
}
