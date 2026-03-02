###############################################################################
# Enterprise Features Configuration
###############################################################################

locals {
  # -- Namespaces --------------------------------------------------------------

  namespaces = {
    team_a = {
      path = "team-a"
    }
    team_b = {
      path = "team-b"
    }
  }

  # -- Raft Storage Autopilot --------------------------------------------------

  raft_autopilot = {
    cleanup_dead_servers               = true
    dead_server_last_contact_threshold = "24h"
    last_contact_threshold             = "10s"
    max_trailing_logs                  = 1000
    min_quorum                         = 3
    server_stabilization_time          = "10s"
  }

  # -- Secret Sync Destinations (Vault 1.16+) ----------------------------------

  secrets_sync_vercel_destinations = {
    vercel_app = {
      name                    = "vercel-frontend"
      access_token            = "dummy-vercel-token"
      project_id              = "prj_dummy12345"
      deployment_environments = ["production", "preview"]
    }
  }

  secrets_sync_gh_destinations = {
    github_repo = {
      name             = "github-repo"
      access_token     = "dummy-gh-token"
      repository_owner = "hashicorp"
      repository_name  = "example-repo"
      secrets_location = "repository"
    }
  }
}
