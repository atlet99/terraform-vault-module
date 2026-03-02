# Authentication Methods in Vault

This guide provides examples and explanations for configuring various authentication methods using the Terraform Vault module.

## 1. Machine-to-Machine Authentication

### AppRole Authentication

AppRole is designed for machine-to-machine authentication. It requires a `role_id` and a `secret_id` to log in.

```hcl
module "vault" {
  source = "git::https://github.com/example/terraform-vault-module.git"

  auth_backends = {
    approle = {
      type        = "approle"
      description = "AppRole authentication"
    }
  }

  approle_auth_roles = {
    my_app = {
      role_name      = "my-app"
      token_policies = ["app_policy"]
      token_ttl      = 3600
    }
  }
}
```

### Kubernetes Authentication

Kubernetes auth allows pods to authenticate with Vault using their Service Account Tokens.

```hcl
module "vault_k8s" {
  source = "..."

  kubernetes_auth_backends = {
    primary = {
      path                   = "kubernetes"
      kubernetes_host        = "https://kubernetes.default.svc"
      disable_iss_validation = true

      roles = {
        app_role = {
          role_name                        = "app-role"
          bound_service_account_names      = ["my-app-sa"]
          bound_service_account_namespaces = ["default", "app-namespace"]
          token_policies                   = ["app_policy"]
        }
      }
    }
  }
}
```

## 2. Cloud IAM Integration

### AWS Auth

AWS Auth allows AWS IAM principals (users or roles) to authenticate with Vault.

```hcl
module "vault_aws" {
  source = "..."

  aws_auth_backends = {
    us_east_1 = {
      path = "aws"
      roles = {
        ec2_role = {
          role_name        = "ec2-role"
          auth_type        = "iam"
          bound_iam_principal_arns = ["arn:aws:iam::123456789012:role/MyEC2Role"]
          token_policies   = ["ec2_policy"]
        }
      }
    }
  }
}
```

## 3. Human Authentication

### OIDC / JWT Authentication

OIDC auth allows users to log in using an external identity provider (IdP) like Okta, Auth0, or Google.

```hcl
module "vault_oidc" {
  source = "..."

  jwt_oidc_auth_backends = {
    okta = {
      path               = "oidc/okta"
      type               = "oidc"
      oidc_discovery_url = "https://dev-123456.okta.com"
      oidc_client_id     = "client-id"
      oidc_client_secret = "client-secret"
      default_role       = "default"
    }
  }

  jwt_oidc_auth_roles = {
    default = {
      role_name             = "default"
      role_type             = "oidc"
      bound_audiences       = ["client-id"]
      user_claim            = "sub"
      token_policies        = ["default"]
      allowed_redirect_uris = ["http://localhost:8200/ui/vault/auth/oidc/oidc/okta/callback"]
    }
  }
}
```
