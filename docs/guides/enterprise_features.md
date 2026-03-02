# Enterprise Features in Vault

This guide demonstrates how to configure enterprise-only features using the Terraform Vault module.

## 1. Managed Keys (Auto-Unseal & External KMS)

Managed Keys allow Vault Enterprise to delegate cryptographic operations to an external Key Management System (KMS), such as AWS KMS, Azure Key Vault, or an HSM via PKCS#11.

```hcl
module "vault_managed_keys" {
  source = "..."

  managed_keys = {
    aws = [
      {
        name               = "aws-kms-unseal"
        access_key         = "AKIA..."
        secret_key         = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
        key_type           = "rsa"
        key_bits           = "2048"
        kms_key            = "arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
        allow_generate_key = true
        allow_replace_key  = true
        allow_store_key    = true
      }
    ]
  }
}
```

## 2. Secrets Synchronization (Vault 1.16+)

Secrets Sync allows Vault Enterprise to push centralized secrets to external secret managers or cloud providers, such as AWS Secrets Manager, GitHub Actions, Vercel, or Azure Key Vault.

### Example: Syncing to Vercel and GitHub

```hcl
module "vault_secrets_sync" {
  source = "..."

  secrets_sync_config = {
    disabled       = false
    queue_capacity = 1000000
  }

  secrets_sync_vercel_destinations = {
    prod_frontend = {
      name                    = "vercel-prod"
      access_token            = "vercel-api-token"
      project_id              = "prj_abc123"
      deployment_environments = ["production"]
    }
  }

  secrets_sync_gh_destinations = {
    backend_repo = {
      name             = "github-backend"
      access_token     = "ghp_xxxxxxxx"
      repository_owner = "my-org"
      repository_name  = "backend-api"
      secrets_location = "repository"
    }
  }

  # Associating an existing Vault KV secret with destination(s)
  secrets_sync_associations = {
    vercel_db_creds = {
      type        = "vercel-project"
      name        = "vercel-prod" # Matches the destination name above
      mount       = "secret"      # The Vault KV mount
      secret_name = "app/db-creds"
    }
    github_api_key = {
      type        = "gh"
      name        = "github-backend"
      mount       = "secret"
      secret_name = "internal/api-key"
    }
  }
}
```

## 3. Logical Multi-Tenancy (Namespaces)

Namespaces allow Vault Enterprise to provide isolated environments (tenants) within a single cluster.

```hcl
module "vault_namespaces" {
  source = "..."

  namespaces = {
    team_a = {
      path = "team-a"
    }
    team_b = {
      path = "team-b"
    }
  }
}
```

_Note: Resources created inside namespaces can be managed by running the module multiple times, passing a different `namespace` to the module inputs or provider._

## 4. Raft Storage Autopilot

Vault's Integrated Storage (Raft) is highly available. Autopilot automates server node management, cleanup, and snapshot scheduling.

```hcl
module "vault_raft" {
  source = "..."

  raft_autopilot = {
    cleanup_dead_servers               = true
    dead_server_last_contact_threshold = "24h"
    last_contact_threshold             = "10s"
    max_trailing_logs                  = 1000
    min_quorum                         = 3
    server_stabilization_time          = "10s"
    disable_upgrade_migration          = false
  }

  raft_snapshot_agent_configs = {
    aws_s3_backup = {
      name                          = "daily-s3-backup"
      interval_seconds              = 86400 # 24 hours
      retain                        = 7
      path_prefix                   = "vault-backups/"
      storage_type                  = "aws-s3"
      aws_s3_bucket                 = "my-vault-backup-bucket"
      aws_s3_region                 = "us-east-1"
      aws_s3_server_side_encryption = true
    }
  }
}
```
