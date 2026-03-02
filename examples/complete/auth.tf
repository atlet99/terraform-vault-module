###############################################################################
# Auth Methods Configuration
###############################################################################

# -- AppRole Auth Roles ----------------------------------------------------
# Used for machine-to-machine authentication

locals {
  approle_auth_roles = {
    app_role = {
      role_name      = "app-role"
      token_policies = ["app_team"]
      token_ttl      = 3600
    }
  }

  # -- JWT/OIDC Auth Roles ---------------------------------------------------
  # Used for human or machine authentication via OIDC providers

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

  # -- Kubernetes Auth ---------------------------------------------------------
  # Used for pods running in Kubernetes

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
}
