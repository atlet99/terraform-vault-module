###############################################################################
# Secrets Engines Configuration
###############################################################################

locals {
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

  # -- Direct KV-V1 Secrets (Example) -----------------------------------------

  kv_secrets = {
    legacy_config = {
      path = "secret/legacy"
      data_json = jsonencode({
        username = "admin"
        password = "supersecretpassword"
      })
    }
  }

  # -- Transit Keys ----------------------------------------------------------
  # Encryption as a Service

  transit_keys = {
    app_key = {
      name             = "app-key-v2"
      backend          = "transit"
      type             = "aes256-gcm96"
      deletion_allowed = true
    }
  }

  # -- PKI Infrastructure (Certificate Management) ----------------------------

  pki_secret_backend_config_cas = {
    root = {
      backend    = "pki" # assuming pki mount exists
      pem_bundle = fileexists("${path.module}/dummy-cert.pem") ? file("${path.module}/dummy-cert.pem") : "-----BEGIN CERTIFICATE-----\nMIIDdzCCAl+g...\n-----END CERTIFICATE-----"
    }
  }
}
