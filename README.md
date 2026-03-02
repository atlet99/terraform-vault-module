# terraform-vault-module

Reusable Terraform module for managing HashiCorp Vault resources: secrets engines, auth backends, policies, audit devices, Kubernetes auth, KV-V2 secrets, namespaces (Enterprise), and generic endpoints.

All resource types are driven by `map(object(...))` variables. Pass an empty map (default) to skip any resource type.

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.10.5 |
| vault     | ~> 5.7.0  |

## Usage

```hcl
module "vault" {
  source = "github.com/atlet99/terraform-vault-module"

  mounts = {
    kv = {
      path    = "secret"
      type    = "kv"
      options = { version = "2" }
    }
    transit = {
      path = "transit"
      type = "transit"
    }
  }

  auth_backends = {
    approle = {
      type = "approle"
    }
  }

  policies = {
    dev = {
      name   = "dev-team"
      policy = <<-EOT
        path "secret/data/dev/*" {
          capabilities = ["create", "read", "update", "list"]
        }
      EOT
    }
  }

  kubernetes_auth_backends = {
    primary = {
      kubernetes_host = "https://kubernetes.default.svc"
      roles = {
        app = {
          role_name                        = "app"
          bound_service_account_names      = ["app-sa"]
          bound_service_account_namespaces = ["default"]
          token_policies                   = ["dev-team"]
          token_ttl                        = 3600
        }
      }
    }
  }

  audit_devices = {
    file = {
      type    = "file"
      options = { file_path = "/vault/logs/audit.log" }
    }
  }

  # -- Identity Management -----------------------------------------------------

  identity_entities = {
    john_doe = {
      name     = "john-doe"
      metadata = { team = "platform" }
      policies = ["dev-team"]
    }
  }

  identity_groups = {
    dev_leads = {
      name     = "dev-leads"
      policies = ["admin"]
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.5 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 5.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.7.0 |

## Resources

| Name | Type |
|------|------|
| [vault_audit.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/audit) | resource |
| [vault_auth_backend.kubernetes](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |
| [vault_auth_backend.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |
| [vault_generic_endpoint.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_endpoint) | resource |
| [vault_identity_entity.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity) | resource |
| [vault_identity_group.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |
| [vault_kubernetes_auth_backend_config.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_config) | resource |
| [vault_kubernetes_auth_backend_role.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_kv_secret_backend_v2.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_backend_v2) | resource |
| [vault_kv_secret_v2.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_mount.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_namespace.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/namespace) | resource |
| [vault_policy.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_audit_devices"></a> [audit\_devices](#input\_audit\_devices) | Map of audit devices to enable. | <pre>map(object({<br/>    type        = string<br/>    path        = optional(string, null)<br/>    description = optional(string, null)<br/>    local       = optional(bool, false)<br/>    namespace   = optional(string, null)<br/>    options     = map(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_auth_backends"></a> [auth\_backends](#input\_auth\_backends) | Map of auth backends to enable. | <pre>map(object({<br/>    type            = string<br/>    path            = optional(string, null)<br/>    description     = optional(string, null)<br/>    local           = optional(bool, false)<br/>    namespace       = optional(string, null)<br/>    disable_remount = optional(bool, false)<br/>    tune = optional(object({<br/>      default_lease_ttl            = optional(string, null)<br/>      max_lease_ttl                = optional(string, null)<br/>      listing_visibility           = optional(string, null)<br/>      audit_non_hmac_request_keys  = optional(list(string), null)<br/>      audit_non_hmac_response_keys = optional(list(string), null)<br/>      passthrough_request_headers  = optional(list(string), null)<br/>      allowed_response_headers     = optional(list(string), null)<br/>      token_type                   = optional(string, null)<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_generic_endpoints"></a> [generic\_endpoints](#input\_generic\_endpoints) | Map of generic endpoints (vault write). | <pre>map(object({<br/>    path                 = string<br/>    namespace            = optional(string, null)<br/>    data_json            = string<br/>    disable_read         = optional(bool, false)<br/>    disable_delete       = optional(bool, false)<br/>    ignore_absent_fields = optional(bool, true)<br/>    write_fields         = optional(list(string), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_identity_entities"></a> [identity\_entities](#input\_identity\_entities) | Map of identity entities to create. | <pre>map(object({<br/>    name              = optional(string, null)<br/>    metadata          = optional(map(string), null)<br/>    policies          = optional(list(string), null)<br/>    external_policies = optional(bool, false)<br/>    disabled          = optional(bool, false)<br/>    namespace         = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_identity_groups"></a> [identity\_groups](#input\_identity\_groups) | Map of identity groups to create. | <pre>map(object({<br/>    name                       = optional(string, null)<br/>    type                       = optional(string, "internal")<br/>    metadata                   = optional(map(string), null)<br/>    policies                   = optional(list(string), null)<br/>    external_policies          = optional(bool, false)<br/>    member_group_ids           = optional(list(string), null)<br/>    member_entity_ids          = optional(list(string), null)<br/>    external_member_entity_ids = optional(bool, false)<br/>    external_member_group_ids  = optional(bool, false)<br/>    namespace                  = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_kubernetes_auth_backends"></a> [kubernetes\_auth\_backends](#input\_kubernetes\_auth\_backends) | Map of Kubernetes auth backend configurations. Each entry creates an auth backend, its config, and associated roles. | <pre>map(object({<br/>    path                              = optional(string, "kubernetes")<br/>    description                       = optional(string, null)<br/>    namespace                         = optional(string, null)<br/>    kubernetes_host                   = string<br/>    kubernetes_ca_cert                = optional(string, null)<br/>    token_reviewer_jwt                = optional(string, null)<br/>    issuer                            = optional(string, null)<br/>    disable_iss_validation            = optional(bool, true)<br/>    disable_local_ca_jwt              = optional(bool, false)<br/>    pem_keys                          = optional(list(string), null)<br/>    use_annotations_as_alias_metadata = optional(bool, null)<br/><br/>    roles = optional(map(object({<br/>      role_name                                = string<br/>      bound_service_account_names              = list(string)<br/>      bound_service_account_namespaces         = optional(list(string), ["default"])<br/>      audience                                 = optional(string, null)<br/>      alias_name_source                        = optional(string, null)<br/>      token_ttl                                = optional(number, null)<br/>      token_max_ttl                            = optional(number, null)<br/>      token_period                             = optional(number, null)<br/>      token_policies                           = optional(list(string), null)<br/>      token_bound_cidrs                        = optional(list(string), null)<br/>      token_explicit_max_ttl                   = optional(number, null)<br/>      token_no_default_policy                  = optional(bool, null)<br/>      token_num_uses                           = optional(number, null)<br/>      token_type                               = optional(string, null)<br/>      bound_service_account_namespace_selector = optional(string, null)<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_kv_secret_backend_v2_config"></a> [kv\_secret\_backend\_v2\_config](#input\_kv\_secret\_backend\_v2\_config) | Map of KV-V2 backend-level configurations. | <pre>map(object({<br/>    mount                = string<br/>    namespace            = optional(string, null)<br/>    max_versions         = optional(number, null)<br/>    cas_required         = optional(bool, null)<br/>    delete_version_after = optional(number, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_kv_secrets_v2"></a> [kv\_secrets\_v2](#input\_kv\_secrets\_v2) | Map of KV-V2 secrets to write. | <pre>map(object({<br/>    mount               = string<br/>    name                = string<br/>    namespace           = optional(string, null)<br/>    cas                 = optional(number, null)<br/>    disable_read        = optional(bool, false)<br/>    delete_all_versions = optional(bool, false)<br/>    data_json           = optional(string, null)<br/>    custom_metadata = optional(object({<br/>      max_versions         = optional(number, null)<br/>      cas_required         = optional(bool, null)<br/>      delete_version_after = optional(number, null)<br/>      data                 = optional(map(string), null)<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_mounts"></a> [mounts](#input\_mounts) | Map of secrets engine mounts to create. | <pre>map(object({<br/>    path                         = string<br/>    type                         = string<br/>    description                  = optional(string, null)<br/>    default_lease_ttl_seconds    = optional(number, null)<br/>    max_lease_ttl_seconds        = optional(number, null)<br/>    local                        = optional(bool, false)<br/>    seal_wrap                    = optional(bool, false)<br/>    external_entropy_access      = optional(bool, false)<br/>    namespace                    = optional(string, null)<br/>    options                      = optional(map(string), null)<br/>    listing_visibility           = optional(string, null)<br/>    allowed_managed_keys         = optional(set(string), null)<br/>    audit_non_hmac_request_keys  = optional(list(string), null)<br/>    audit_non_hmac_response_keys = optional(list(string), null)<br/>    passthrough_request_headers  = optional(list(string), null)<br/>    allowed_response_headers     = optional(list(string), null)<br/>    delegated_auth_accessors     = optional(list(string), null)<br/>    plugin_version               = optional(string, null)<br/>    identity_token_key           = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | Map of Vault Enterprise namespaces to create. | <pre>map(object({<br/>    path            = string<br/>    namespace       = optional(string, null)<br/>    custom_metadata = optional(map(string), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | Map of Vault policies to create. The value of 'policy' is an HCL policy string. | <pre>map(object({<br/>    name      = string<br/>    policy    = string<br/>    namespace = optional(string, null)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_audit_device_paths"></a> [audit\_device\_paths](#output\_audit\_device\_paths) | Map of audit device keys to their paths. |
| <a name="output_audit_devices"></a> [audit\_devices](#output\_audit\_devices) | Full audit device objects keyed by variable key. Contains path, type, and id. |
| <a name="output_auth_backend_accessors"></a> [auth\_backend\_accessors](#output\_auth\_backend\_accessors) | Map of auth backend keys to their accessors. |
| <a name="output_auth_backend_paths"></a> [auth\_backend\_paths](#output\_auth\_backend\_paths) | Map of auth backend keys to their paths. |
| <a name="output_auth_backends"></a> [auth\_backends](#output\_auth\_backends) | Full auth backend objects keyed by variable key. Contains path, accessor, type, and description. |
| <a name="output_generic_endpoint_write_data"></a> [generic\_endpoint\_write\_data](#output\_generic\_endpoint\_write\_data) | Map of generic endpoint keys to their write\_data maps. |
| <a name="output_generic_endpoint_write_data_json"></a> [generic\_endpoint\_write\_data\_json](#output\_generic\_endpoint\_write\_data\_json) | Map of generic endpoint keys to their write\_data\_json strings. |
| <a name="output_generic_endpoints"></a> [generic\_endpoints](#output\_generic\_endpoints) | Full generic endpoint objects keyed by variable key. Contains path, write\_data, and write\_data\_json. |
| <a name="output_identity_entities"></a> [identity\_entities](#output\_identity\_entities) | Full identity entity objects keyed by variable key. Contains name and id. |
| <a name="output_identity_entity_ids"></a> [identity\_entity\_ids](#output\_identity\_entity\_ids) | Map of identity entity keys to their IDs. |
| <a name="output_identity_group_ids"></a> [identity\_group\_ids](#output\_identity\_group\_ids) | Map of identity group keys to their IDs. |
| <a name="output_identity_groups"></a> [identity\_groups](#output\_identity\_groups) | Full identity group objects keyed by variable key. Contains name and id. |
| <a name="output_kubernetes_auth_backend_accessors"></a> [kubernetes\_auth\_backend\_accessors](#output\_kubernetes\_auth\_backend\_accessors) | Map of Kubernetes auth backend keys to their accessors. |
| <a name="output_kubernetes_auth_backend_paths"></a> [kubernetes\_auth\_backend\_paths](#output\_kubernetes\_auth\_backend\_paths) | Map of Kubernetes auth backend keys to their paths. |
| <a name="output_kubernetes_auth_backends"></a> [kubernetes\_auth\_backends](#output\_kubernetes\_auth\_backends) | Full Kubernetes auth backend objects keyed by variable key. Contains path, accessor, and id. |
| <a name="output_kubernetes_auth_roles"></a> [kubernetes\_auth\_roles](#output\_kubernetes\_auth\_roles) | Map of Kubernetes auth role composite keys (backend/role) to their role names and backend paths. |
| <a name="output_kv_secret_v2_metadata"></a> [kv\_secret\_v2\_metadata](#output\_kv\_secret\_v2\_metadata) | Map of KV-V2 secret keys to their metadata. |
| <a name="output_kv_secret_v2_paths"></a> [kv\_secret\_v2\_paths](#output\_kv\_secret\_v2\_paths) | Map of KV-V2 secret keys to their full paths. |
| <a name="output_kv_secrets_v2"></a> [kv\_secrets\_v2](#output\_kv\_secrets\_v2) | Full KV-V2 secret objects keyed by variable key. Contains path, mount, and name. |
| <a name="output_mount_accessors"></a> [mount\_accessors](#output\_mount\_accessors) | Map of mount keys to their accessors. |
| <a name="output_mount_paths"></a> [mount\_paths](#output\_mount\_paths) | Map of mount keys to their paths. |
| <a name="output_mounts"></a> [mounts](#output\_mounts) | Full mount objects keyed by variable key. Contains path, accessor, type, and description. |
| <a name="output_namespace_ids"></a> [namespace\_ids](#output\_namespace\_ids) | Map of namespace keys to their Vault-internal namespace IDs. |
| <a name="output_namespace_paths"></a> [namespace\_paths](#output\_namespace\_paths) | Map of namespace keys to their fully qualified paths. |
| <a name="output_namespaces"></a> [namespaces](#output\_namespaces) | Full namespace objects keyed by variable key. Contains path, path\_fq, namespace\_id, and id. |
| <a name="output_policies"></a> [policies](#output\_policies) | Full policy objects keyed by variable key. Contains name and id. |
| <a name="output_policy_names"></a> [policy\_names](#output\_policy\_names) | Map of policy keys to their names. |
<!-- END_TF_DOCS -->

## Make Targets

```
make help               Show available targets
make check-deps         Check if required tools are installed
make fmt                Run terraform fmt
make validate           Run terraform validate
make docs               Generate docs with terraform-docs
make lint               Run tflint
make check-all          Run all checks (fmt, validate, lint, docs)
make changelog          Generate CHANGELOG.md with git-cliff
make changelog-preview  Preview next version and unreleased changes
make release            Release version: make release [VERSION=x.y.z]
make tag                Create a tag: make tag [VERSION=x.y.z]
make clean              Remove terraform artifacts
```

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
