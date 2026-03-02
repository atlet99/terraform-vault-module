###############################################################################
# Identity Configuration
###############################################################################

locals {
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

  # -- Entities and Groups -----------------------------------------------------

  identity_entities = {
    test_user = {
      name     = "test-user"
      policies = ["readonly"]
      metadata = {
        department = "engineering"
      }
    }
  }

  identity_groups = {
    engineering = {
      name     = "engineering-group"
      type     = "internal"
      policies = ["app_team"]
      metadata = {
        cost_center = "R&D"
      }
    }
  }

  identity_group_memberships = {
    eng_test_user = {
      group_id          = module.vault.identity_groups["engineering"].id
      member_entity_ids = [module.vault.identity_entities["test_user"].id]
    }
  }
}
