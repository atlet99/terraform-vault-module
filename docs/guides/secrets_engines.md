# Secrets Engines in Vault

This guide covers how to set up and manage different types of Secrets Engines using the Terraform Vault module.

## 1. Static Secrets (KV-V2)

The KV Secrets Engine (Version 2) stores arbitrary key/value secrets. It supports versioning, allowing you to roll back to older versions of a secret.

```hcl
module "vault_kv" {
  source = "atlet99/module/vault"
  version = "~> 1.0.2"

  mounts = {
    kv = {
      path           = "secret"
      type           = "kv"
      options        = { version = "2" }
    }
  }

  kv_secret_backend_v2_config = {
    secret = {
      mount        = "secret"
      max_versions = 10
      cas_required = false
    }
  }

  kv_secrets_v2 = {
    db_creds = {
      mount = "secret"
      name  = "database/credentials"
      data_json = jsonencode({
        username = "admin"
        password = "supersecretpassword"
      })
    }
  }
}
```

## 2. Dynamic Secrets (Database, Cloud IAM)

Dynamic secrets are generated on-demand and are unique to the client that requested them. They are tied to a Vault lease.

### Example: Database Engines (PostgreSQL)

```hcl
module "vault_db" {
  source = "atlet99/module/vault"
  version = "~> 1.0.2"

  mounts = {
    database = {
      path = "database"
      type = "database"
    }
  }

  database_secret_backend_connections = {
    postgres = {
      name           = "my-postgres"
      plugin_name    = "postgresql-database-plugin"
      allowed_roles  = ["readonly"]
      connection_url = "postgresql://{{username}}:{{password}}@localhost:5432/postgres?sslmode=disable"
      username       = "root"
      password       = "rootpassword"
    }
  }

  database_secret_backend_roles = {
    readonly = {
      name    = "readonly"
      db_name = "my-postgres"
      creation_statements = [
        "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
        "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
      ]
      default_ttl = 3600
      max_ttl     = 86400
    }
  }
}
```

## 3. Encryption as a Service (Transit)

The Transit Secrets Engine handles cryptographic functions on data in-transit. Vault doesn't store the data sent to the transit engine.

```hcl
module "vault_transit" {
  source = "atlet99/module/vault"
  version = "~> 1.0.2"

  mounts = {
    transit = {
      path = "transit"
      type = "transit"
    }
  }

  transit_keys = {
    order_encryption_key = {
      name             = "order-encryption-key"
      backend          = "transit"
      type             = "aes256-gcm96"
      deletion_allowed = false
    }
  }
}
```

## 4. PKI Infrastructure (Certificates)

The PKI Secrets Engine allows Vault to act as an internal Certificate Authority (CA), dynamically generating X.509 certificates on demand.

```hcl
module "vault_pki" {
  source = "atlet99/module/vault"
  version = "~> 1.0.2"

  mounts = {
    pki_root = {
      path                  = "pki"
      type                  = "pki"
      max_lease_ttl_seconds = 315360000 # 10 years
    }
  }

  pki_secret_backend_roles = {
    app_certs = {
      name             = "app-certs"
      allowed_domains  = ["internal.example.com"]
      allow_subdomains = true
      max_ttl          = "720h"
    }
  }
}
```
