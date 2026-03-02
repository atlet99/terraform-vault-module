# Practical Scenario: Self-Hosted Vault with Raft and LDAP

This guide demonstrates a common real-world scenario: deploying a self-hosted Vault cluster on virtual machines (e.g., EC2, VMware, bare metal) using **Raft Integrated Storage** for high availability and **LDAP (Active Directory)** for centralized employee authentication.

## Architecture Overview

- **Storage**: Raft (Integrated Storage). No external dependencies like Consul or PostgreSQL are needed.
- **Authentication**: LDAP. Maps external Active Directory groups to Vault internal policies.
- **Access Control**: Two basic policies: `admin` (full access) and `developer` (limited access to specific paths).

## Terraform Configuration

Below is the complete Terraform module block required to configure this scenario.

```hcl
module "vault_selfhosted" {
  source = "atlet99/module/vault"
  version = "~> 1.0.2"

  # ---------------------------------------------------------------------------
  # 1. Policies Configurations
  # ---------------------------------------------------------------------------

  policies = {
    admin_policy = {
      name   = "admin"
      policy = <<-EOT
        # Manage auth methods broadly across Vault
        path "auth/*" {
          capabilities = ["create", "read", "update", "delete", "list", "sudo"]
        }

        # Create, update, and delete auth methods
        path "sys/auth/*" {
          capabilities = ["create", "update", "delete", "sudo"]
        }

        # List auth methods
        path "sys/auth" {
          capabilities = ["read"]
        }

        # Enable and manage the key/value secrets engine at `secret/` path
        # List, create, update, and delete key/value secrets
        path "secret/*" {
          capabilities = ["create", "read", "update", "delete", "list", "sudo"]
        }

        # Manage secret engines broadly
        path "sys/mounts/*" {
          capabilities = ["create", "read", "update", "delete", "list", "sudo"]
        }

        # List existing secret engines
        path "sys/mounts" {
          capabilities = ["read"]
        }
      EOT
    }

    developer_policy = {
      name   = "developer"
      policy = <<-EOT
        # Read and List access to the application secrets
        path "secret/data/applications/*" {
          capabilities = ["read", "list"]
        }

        # Allow developers to change their own password
        path "identity/entity/id/{{identity.entity.id}}" {
          capabilities = ["update"]
        }
      EOT
    }
  }

  # ---------------------------------------------------------------------------
  # 2. Key/Value Secrets Engine Mount
  # ---------------------------------------------------------------------------

  mounts = {
    kv_apps = {
      path           = "secret"
      type           = "kv"
      description    = "KV Version 2 secret engine for applications"
      options        = { version = "2" }
    }
  }

  # ---------------------------------------------------------------------------
  # 3. Raft Autopilot Settings
  # ---------------------------------------------------------------------------
  # Ensures the cluster automatically cleans up dead nodes and manages quorum.

  raft_autopilot = {
    cleanup_dead_servers               = true
    dead_server_last_contact_threshold = "24h"
    last_contact_threshold             = "10s"
    max_trailing_logs                  = 1000
    min_quorum                         = 3
    server_stabilization_time          = "10s"
  }

  # ---------------------------------------------------------------------------
  # 4. LDAP Authentication Backend
  # ---------------------------------------------------------------------------

  ldap_auth_backends = {
    corp_ad = {
      path        = "ldap"
      description = "Corporate Active Directory"
      url         = "ldaps://ldap.example.com"
      userdn      = "OU=Users,DC=example,DC=com"
      userattr    = "sAMAccountName"
      upndomain   = "example.com"
      discoverdn  = false
      groupdn     = "OU=Groups,DC=example,DC=com"
      groupfilter = "(&(objectClass=group)(member={{.UserDN}}))"
      groupattr   = "cn"
      binddn      = "CN=Vault Service Account,OU=ServiceAccounts,DC=example,DC=com"
      bindpass    = "super-secure-service-account-password"

      # Allow Vault to automatically map LDAP groups to Vault Identity Groups
      token_bound_cidrs = ["10.0.0.0/8"]
    }
  }

  # ---------------------------------------------------------------------------
  # 5. LDAP Group Mapping
  # ---------------------------------------------------------------------------
  # Map external Active Directory groups to internal Vault policies.

  ldap_auth_groups = {
    vault_administrators = {
      groupname = "Vault Admins"     # Name of the group in AD
      policies  = ["admin"]          # Assign the admin policy defined above
      backend   = "ldap"             # Mount path
    }

    application_developers = {
      groupname = "App Developers"   # Name of the group in AD
      policies  = ["developer"]      # Assign the developer policy defined above
      backend   = "ldap"
    }
  }
}
```

## How It Works

1. **Infrastructure**: You provision 3 or 5 Virtual Machines natively running the Vault binary. You initialize the first node and join the others to form a Raft cluster.
2. **Terraform Apply**: You run `terraform apply` using this module block against the active cluster manager.
3. **Execution**:
   - The module configures **Raft Autopilot** to automatically manage the nodes (e.g., evicting nodes that have been offline for 24 hours).
   - The module sets up **LDAP** utilizing a service account (`binddn`) to query the corporate directory (`ldaps://ldap.example.com`).
   - The module creates two **Policies**: a highly privileged `admin` policy and a restricted `developer` policy.
   - Finally, it logically maps the AD group `"Vault Admins"` to the `admin` policy, and the `"App Developers"` group to the `developer` policy.

When a user in the "Vault Admins" AD group logs into Vault using their corporate credentials (`vault login -method=ldap username=johndoe`), they will automatically receive a token with the `admin` permissions.
