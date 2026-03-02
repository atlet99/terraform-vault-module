# Identity Management in Vault

The Identity Secrets Engine acts as Vault's primary identity management system. It maintains identities (Entities) and logically groups them (Groups).

This guide shows how to map authentication clients to logical identities and assign policies based on these identities.

## 1. Entities and Aliases

An **Entity** represents a single logical user or machine. An **Alias** ties an authentication backend login (e.g., a specific GitHub user) to that Entity.

If a user logs in via GitHub and OIDC, mapping aliases for both to a single Entity ensures consistent policy application regardless of the login method.

```hcl
module "vault_identity" {
  source = "atlet99/module/vault"
  version = "~> 1.0.2"

  identity_entities = {
    john_doe = {
      name     = "john.doe"
      policies = ["default_user_policy"]
      metadata = {
        department = "engineering"
        email      = "john.doe@example.com"
      }
    }
  }
}
```

_Note: The module currently supports creating entities. Alias mapping might require additional custom Terraform data sources for optimal integration depending on the environment._

## 2. Identity Groups

**Groups** allow you to consolidate policy mapping and metadata. An entity assigned to a group inherits its policies.

```hcl
module "vault_groups" {
  source = "atlet99/module/vault"
  version = "~> 1.0.2"

  identity_groups = {
    engineering_team = {
      name     = "engineering"
      type     = "internal" # Internal groups are manually managed in Vault
      policies = ["eng_policy", "read_all_secrets"]
      metadata = {
        cost_center = "cc-1234"
      }
    }
  }

  identity_group_member_entity_ids = {
    john_in_eng = {
      group_id  = module.vault_groups.identity_groups["engineering_team"].id
      entity_id = module.vault_groups.identity_entities["john_doe"].id
    }
  }
}
```

## 3. Nested Groups (Groups within Groups)

Vault supports nested groups (a group as a member of another group). This is useful for building hierarchical organizational structures.

```hcl
module "vault_nested_groups" {
  source = "atlet99/module/vault"
  version = "~> 1.0.2"

  identity_groups = {
    all_employees = {
      name     = "all-employees"
      type     = "internal"
      policies = ["base_access"]
    }

    engineering_team = {
      name     = "engineering"
      type     = "internal"
      policies = ["eng_policy"]
    }
  }

  identity_group_member_group_ids = {
    eng_in_all = {
      group_id        = module.vault_nested_groups.identity_groups["all_employees"].id
      member_group_id = module.vault_nested_groups.identity_groups["engineering_team"].id
    }
  }
}
```

## 4. OIDC Group Mapping (External Groups)

When using OIDC or LDAP, Vault can automatically map groups provided by the Identity Provider (IdP) to Vault Identity Groups.

```hcl
module "vault_external_groups" {
  source = "atlet99/module/vault"
  version = "~> 1.0.2"

  identity_groups = {
    okta_dev_group = {
      name     = "okta-developers"
      type     = "external" # External groups rely on alias mapping
      policies = ["dev_policy"]
    }
  }

  identity_group_aliases = {
    okta_mapping = {
      name           = "Developers" # The group name coming from Okta
      mount_accessor = module.vault_groups.jwt_oidc_auth_backends["okta"].accessor
      canonical_id   = module.vault_groups.identity_groups["okta_dev_group"].id
    }
  }
}
```
