###############################################################################
# Auth Backends
###############################################################################

variable "kubernetes_auth_backends" {
  description = "Map of Kubernetes auth backend configurations. Each entry creates an auth backend, its config, and associated roles."
  type = map(object({
    path                              = optional(string, "kubernetes")
    description                       = optional(string, null)
    namespace                         = optional(string, null)
    kubernetes_host                   = string
    kubernetes_ca_cert                = optional(string, null)
    token_reviewer_jwt                = optional(string, null)
    issuer                            = optional(string, null)
    disable_iss_validation            = optional(bool, true)
    disable_local_ca_jwt              = optional(bool, false)
    pem_keys                          = optional(list(string), null)
    use_annotations_as_alias_metadata = optional(bool, null)

    roles = optional(map(object({
      role_name                                = string
      bound_service_account_names              = list(string)
      bound_service_account_namespaces         = optional(list(string), ["default"])
      audience                                 = optional(string, null)
      alias_name_source                        = optional(string, null)
      token_ttl                                = optional(number, null)
      token_max_ttl                            = optional(number, null)
      token_period                             = optional(number, null)
      token_policies                           = optional(list(string), null)
      token_bound_cidrs                        = optional(list(string), null)
      token_explicit_max_ttl                   = optional(number, null)
      token_no_default_policy                  = optional(bool, null)
      token_num_uses                           = optional(number, null)
      token_type                               = optional(string, null)
      bound_service_account_namespace_selector = optional(string, null)
    })), {})
  }))
  default = {}
}

variable "approle_auth_roles" {
  description = "Map of AppRole auth backend roles to create."
  type = map(object({
    role_name               = string
    backend                 = optional(string, "approle")
    role_id                 = optional(string, null)
    bind_secret_id          = optional(bool, true)
    secret_id_bound_cidrs   = optional(set(string), null)
    secret_id_num_uses      = optional(number, null)
    secret_id_ttl           = optional(number, null)
    local_secret_ids        = optional(bool, false)
    token_ttl               = optional(number, null)
    token_max_ttl           = optional(number, null)
    token_period            = optional(number, null)
    token_policies          = optional(list(string), null)
    token_bound_cidrs       = optional(list(string), null)
    token_explicit_max_ttl  = optional(number, null)
    token_no_default_policy = optional(bool, null)
    token_num_uses          = optional(number, null)
    token_type              = optional(string, null)
    namespace               = optional(string, null)
  }))
  default = {}
}

variable "jwt_oidc_auth_roles" {
  description = "Map of JWT/OIDC auth backend roles to create."
  type = map(object({
    role_name                    = string
    backend                      = optional(string, "jwt")
    role_type                    = optional(string, "oidc")
    bound_audiences              = optional(set(string), null)
    user_claim                   = string
    user_claim_json_pointer      = optional(bool, false)
    clock_skew_leeway            = optional(number, 0)
    expiration_leeway            = optional(number, 0)
    not_before_leeway            = optional(number, 0)
    allowed_redirect_uris        = optional(set(string), null)
    bound_subject                = optional(string, null)
    oidc_scopes                  = optional(set(string), null)
    bound_claims_type            = optional(string, null)
    bound_claims                 = optional(map(string), null)
    disable_bound_claims_parsing = optional(bool, false)
    claim_mappings               = optional(map(string), null)
    groups_claim                 = optional(string, null)
    verbose_oidc_logging         = optional(bool, false)
    max_age                      = optional(number, null)
    token_ttl                    = optional(number, null)
    token_max_ttl                = optional(number, null)
    token_period                 = optional(number, null)
    token_policies               = optional(list(string), null)
    token_bound_cidrs            = optional(list(string), null)
    token_explicit_max_ttl       = optional(number, null)
    token_no_default_policy      = optional(bool, null)
    token_num_uses               = optional(number, null)
    token_type                   = optional(string, null)
    namespace                    = optional(string, null)
  }))
  default = {}
}

variable "github_auth_backends" {
  description = "Map of GitHub auth backend configurations (organization settings)."
  type = map(object({
    path            = string
    organization    = string
    organization_id = optional(number, null)
    base_url        = optional(string, null)
    description     = optional(string, null)
    namespace       = optional(string, null)
    tune = optional(object({
      default_lease_ttl  = optional(string, null)
      max_lease_ttl      = optional(string, null)
      listing_visibility = optional(string, null)
      token_type         = optional(string, null)
    }), null)
  }))
  default = {}
}

variable "aws_auth_backends" {
  description = "Map of AWS auth backends along with their client configurations."
  type = map(object({
    path                       = string
    description                = optional(string, null)
    namespace                  = optional(string, null)
    access_key                 = optional(string, null)
    secret_key                 = optional(string, null)
    ec2_endpoint               = optional(string, null)
    iam_endpoint               = optional(string, null)
    sts_endpoint               = optional(string, null)
    sts_region                 = optional(string, null)
    allowed_sts_header_values  = optional(set(string), null)
    iam_server_id_header_value = optional(string, null)
    role_arn                   = optional(string, null)
    identity_token_audience    = optional(string, null)
    max_retries                = optional(number, null)
    tune = optional(object({
      default_lease_ttl            = optional(string, null)
      max_lease_ttl                = optional(string, null)
      listing_visibility           = optional(string, null)
      audit_non_hmac_request_keys  = optional(list(string), null)
      audit_non_hmac_response_keys = optional(list(string), null)
      passthrough_request_headers  = optional(list(string), null)
      allowed_response_headers     = optional(list(string), null)
      token_type                   = optional(string, null)
    }), null)
  }))
  default = {}
}

variable "aws_auth_roles" {
  description = "Map of AWS auth backend roles."
  type = map(object({
    role                            = string
    backend                         = optional(string, "aws")
    auth_type                       = optional(string, "iam")
    bound_ami_ids                   = optional(set(string), null)
    bound_account_ids               = optional(set(string), null)
    bound_regions                   = optional(set(string), null)
    bound_vpc_ids                   = optional(set(string), null)
    bound_subnet_ids                = optional(set(string), null)
    bound_iam_role_arns             = optional(set(string), null)
    bound_iam_instance_profile_arns = optional(set(string), null)
    bound_ec2_instance_ids          = optional(set(string), null)
    role_tag                        = optional(string, null)
    bound_iam_principal_arns        = optional(set(string), null)
    inferred_entity_type            = optional(string, null)
    inferred_aws_region             = optional(string, null)
    resolve_aws_unique_ids          = optional(bool, true)
    allow_instance_migration        = optional(bool, false)
    disallow_reauthentication       = optional(bool, false)
    token_ttl                       = optional(number, null)
    token_max_ttl                   = optional(number, null)
    token_period                    = optional(number, null)
    token_policies                  = optional(set(string), null)
    token_bound_cidrs               = optional(set(string), null)
    token_explicit_max_ttl          = optional(number, null)
    token_no_default_policy         = optional(bool, null)
    token_num_uses                  = optional(number, null)
    token_type                      = optional(string, null)
  }))
  default = {}
}

variable "azure_auth_backends" {
  description = "Map of Azure auth backends config."
  type = map(object({
    path          = string
    description   = optional(string, null)
    namespace     = optional(string, null)
    tenant_id     = string
    client_id     = optional(string, null)
    client_secret = optional(string, null)
    resource      = string
    environment   = optional(string, "AzurePublicCloud")
    tune = optional(object({
      default_lease_ttl            = optional(string, null)
      max_lease_ttl                = optional(string, null)
      listing_visibility           = optional(string, null)
      audit_non_hmac_request_keys  = optional(list(string), null)
      audit_non_hmac_response_keys = optional(list(string), null)
      passthrough_request_headers  = optional(list(string), null)
      allowed_response_headers     = optional(list(string), null)
      token_type                   = optional(string, null)
    }), null)
  }))
  default = {}
}

variable "azure_auth_roles" {
  description = "Map of Azure auth roles."
  type = map(object({
    role                        = string
    backend                     = optional(string, "azure")
    bound_service_principal_ids = optional(list(string), null)
    bound_group_ids             = optional(list(string), null)
    bound_locations             = optional(list(string), null)
    bound_subscription_ids      = optional(list(string), null)
    bound_resource_groups       = optional(list(string), null)
    bound_scale_sets            = optional(list(string), null)
    token_ttl                   = optional(number, null)
    token_max_ttl               = optional(number, null)
    token_period                = optional(number, null)
    token_policies              = optional(set(string), null)
    token_bound_cidrs           = optional(set(string), null)
    token_explicit_max_ttl      = optional(number, null)
    token_no_default_policy     = optional(bool, null)
    token_num_uses              = optional(number, null)
    token_type                  = optional(string, null)
  }))
  default = {}
}

variable "gcp_auth_backends" {
  description = "Map of GCP auth backends."
  type = map(object({
    path                    = optional(string, "gcp")
    description             = optional(string, null)
    local                   = optional(bool, false)
    credentials             = optional(string, null)
    client_email            = optional(string, null)
    project_id              = optional(string, null)
    identity_token_audience = optional(string, null)
    identity_token_ttl      = optional(number, null)
    identity_token_key      = optional(string, null)
    service_account_email   = optional(string, null)
    iam_alias               = optional(string, null)
    iam_metadata            = optional(set(string), null)
    gce_alias               = optional(string, null)
    gce_metadata            = optional(set(string), null)
    tune = optional(object({
      default_lease_ttl            = optional(string, null)
      max_lease_ttl                = optional(string, null)
      listing_visibility           = optional(string, null)
      audit_non_hmac_request_keys  = optional(list(string), null)
      audit_non_hmac_response_keys = optional(list(string), null)
      passthrough_request_headers  = optional(list(string), null)
      allowed_response_headers     = optional(list(string), null)
      token_type                   = optional(string, null)
    }), null)
  }))
  default = {}
}

variable "gcp_auth_roles" {
  description = "Map of GCP auth roles."
  type = map(object({
    role                    = string
    backend                 = optional(string, "gcp")
    type                    = string
    bound_projects          = optional(set(string), null)
    add_group_aliases       = optional(bool, null)
    max_jwt_exp             = optional(string, null)
    allow_gce_inference     = optional(bool, null)
    bound_service_accounts  = optional(set(string), null)
    bound_zones             = optional(set(string), null)
    bound_regions           = optional(set(string), null)
    bound_instance_groups   = optional(set(string), null)
    bound_labels            = optional(set(string), null)
    token_ttl               = optional(number, null)
    token_max_ttl           = optional(number, null)
    token_period            = optional(number, null)
    token_policies          = optional(set(string), null)
    token_bound_cidrs       = optional(set(string), null)
    token_explicit_max_ttl  = optional(number, null)
    token_no_default_policy = optional(bool, null)
    token_num_uses          = optional(number, null)
    token_type              = optional(string, null)
  }))
  default = {}
}

variable "ldap_auth_backends" {
  description = "Map of LDAP auth backends."
  type = map(object({
    path                        = optional(string, "ldap")
    description                 = optional(string, null)
    local                       = optional(bool, false)
    url                         = string
    starttls                    = optional(bool, null)
    tls_min_version             = optional(string, null)
    tls_max_version             = optional(string, null)
    insecure_tls                = optional(bool, null)
    certificate                 = optional(string, null)
    binddn                      = optional(string, null)
    bindpass                    = optional(string, null)
    case_sensitive_names        = optional(bool, null)
    max_page_size               = optional(number, null)
    userdn                      = optional(string, null)
    userattr                    = optional(string, null)
    userfilter                  = optional(string, null)
    discoverdn                  = optional(bool, null)
    deny_null_bind              = optional(bool, null)
    upndomain                   = optional(string, null)
    groupfilter                 = optional(string, null)
    groupdn                     = optional(string, null)
    groupattr                   = optional(string, null)
    username_as_alias           = optional(bool, null)
    use_token_groups            = optional(bool, null)
    client_tls_cert             = optional(string, null)
    client_tls_key              = optional(string, null)
    connection_timeout          = optional(number, null)
    request_timeout             = optional(number, null)
    dereference_aliases         = optional(string, null)
    enable_samaccountname_login = optional(bool, null)
    anonymous_group_search      = optional(bool, null)
    tune = optional(object({
      default_lease_ttl            = optional(string, null)
      max_lease_ttl                = optional(string, null)
      listing_visibility           = optional(string, null)
      audit_non_hmac_request_keys  = optional(list(string), null)
      audit_non_hmac_response_keys = optional(list(string), null)
      passthrough_request_headers  = optional(list(string), null)
      allowed_response_headers     = optional(list(string), null)
      token_type                   = optional(string, null)
    }), null)
  }))
  default = {}
}

variable "ldap_auth_groups" {
  description = "Map of LDAP auth groups."
  type = map(object({
    groupname = string
    backend   = optional(string, "ldap")
    policies  = optional(set(string), null)
  }))
  default = {}
}

variable "okta_auth_backends" {
  description = "Map of Okta auth backends."
  type = map(object({
    path            = optional(string, "okta")
    description     = optional(string, null)
    organization    = string
    token           = optional(string, null)
    base_url        = optional(string, null)
    bypass_okta_mfa = optional(bool, null)
    tune = optional(object({
      default_lease_ttl            = optional(string, null)
      max_lease_ttl                = optional(string, null)
      listing_visibility           = optional(string, null)
      audit_non_hmac_request_keys  = optional(list(string), null)
      audit_non_hmac_response_keys = optional(list(string), null)
      passthrough_request_headers  = optional(list(string), null)
      allowed_response_headers     = optional(list(string), null)
      token_type                   = optional(string, null)
    }), null)
  }))
  default = {}
}

variable "okta_auth_groups" {
  description = "Map of Okta auth groups."
  type = map(object({
    group_name = string
    path       = string
    policies   = optional(set(string), null)
  }))
  default = {}
}

variable "okta_auth_users" {
  description = "Map of Okta auth users."
  type = map(object({
    username = string
    path     = string
    groups   = optional(set(string), null)
    policies = optional(set(string), null)
  }))
  default = {}
}

variable "cert_auth_backends" {
  description = "Map of Cert auth backends."
  type = map(object({
    path        = string
    description = optional(string, null)
    namespace   = optional(string, null)
    tune = optional(object({
      default_lease_ttl            = optional(string, null)
      max_lease_ttl                = optional(string, null)
      listing_visibility           = optional(string, null)
      audit_non_hmac_request_keys  = optional(list(string), null)
      audit_non_hmac_response_keys = optional(list(string), null)
      passthrough_request_headers  = optional(list(string), null)
      allowed_response_headers     = optional(list(string), null)
      token_type                   = optional(string, null)
    }), null)
  }))
  default = {}
}

variable "cert_auth_roles" {
  description = "Map of Cert auth roles."
  type = map(object({
    name                         = string
    backend                      = optional(string, "cert")
    certificate                  = string
    allowed_names                = optional(set(string), null)
    allowed_common_names         = optional(set(string), null)
    allowed_dns_sans             = optional(set(string), null)
    allowed_email_sans           = optional(set(string), null)
    allowed_uri_sans             = optional(set(string), null)
    allowed_organizational_units = optional(set(string), null)
    required_extensions          = optional(set(string), null)
    display_name                 = optional(string, null)
    ocsp_ca_certificates         = optional(string, null)
    ocsp_servers_override        = optional(set(string), null)
    ocsp_enabled                 = optional(bool, null)
    ocsp_fail_open               = optional(bool, null)
    ocsp_query_all_servers       = optional(bool, null)
    ocsp_max_retries             = optional(number, null)
    ocsp_this_update_max_age     = optional(number, null)
    token_ttl                    = optional(number, null)
    token_max_ttl                = optional(number, null)
    token_period                 = optional(number, null)
    token_policies               = optional(set(string), null)
    token_bound_cidrs            = optional(set(string), null)
    token_explicit_max_ttl       = optional(number, null)
    token_no_default_policy      = optional(bool, null)
    token_num_uses               = optional(number, null)
    token_type                   = optional(string, null)
  }))
  default = {}
}

variable "token_auth_backend_roles" {
  description = "Map of Token auth backend roles."
  type = map(object({
    role_name                = string
    allowed_policies         = optional(set(string), null)
    allowed_policies_glob    = optional(set(string), null)
    disallowed_policies      = optional(set(string), null)
    disallowed_policies_glob = optional(set(string), null)
    orphan                   = optional(bool, false)
    allowed_entity_aliases   = optional(set(string), null)
    renewable                = optional(bool, true)
    path_suffix              = optional(string, "")
    token_ttl                = optional(number, null)
    token_max_ttl            = optional(number, null)
    token_period             = optional(number, null)
    token_explicit_max_ttl   = optional(number, null)
    token_no_default_policy  = optional(bool, null)
    token_num_uses           = optional(number, null)
    token_type               = optional(string, null)
    token_bound_cidrs        = optional(list(string), null)
    namespace                = optional(string, null)
  }))
  default = {}
}

variable "audit_request_headers" {
  description = "Map of Audit request headers to track."
  type = map(object({
    name      = string
    hmac      = optional(bool, false)
    namespace = optional(string, null)
  }))
  default = {}
}

###############################################################################
# Additional Auth Backends: SAML, SPIFFE, OCI, AliCloud
###############################################################################

variable "saml_auth_backends" {
  description = "A map of SAML auth backends to configure."
  type = map(object({
    path                         = optional(string, "saml")
    description                  = optional(string)
    idp_metadata_url             = optional(string)
    idp_sso_url                  = optional(string)
    idp_entity_id                = optional(string)
    idp_cert                     = optional(string)
    entity_id                    = optional(string)
    acs_urls                     = optional(list(string))
    default_role                 = optional(string)
    verbose_logging              = optional(bool)
    validate_assertion_signature = optional(bool)
    validate_response_signature  = optional(bool)
    disable_remount              = optional(bool)
    namespace                    = optional(string)
    tune = optional(object({
      default_lease_ttl            = optional(string)
      max_lease_ttl                = optional(string)
      listing_visibility           = optional(string)
      audit_non_hmac_request_keys  = optional(list(string))
      audit_non_hmac_response_keys = optional(list(string))
      passthrough_request_headers  = optional(list(string))
      allowed_response_headers     = optional(list(string))
      token_type                   = optional(string)
    }))
  }))
  default = {}
}

variable "saml_auth_roles" {
  description = "A map of SAML auth backend roles to configure."
  type = map(object({
    path                    = string
    name                    = string
    groups_attribute        = optional(string)
    bound_subjects          = optional(list(string))
    bound_subjects_type     = optional(string)
    bound_attributes        = optional(map(string))
    bound_attributes_type   = optional(string)
    token_ttl               = optional(number)
    token_max_ttl           = optional(number)
    token_period            = optional(number)
    token_policies          = optional(list(string))
    token_bound_cidrs       = optional(list(string))
    token_explicit_max_ttl  = optional(number)
    token_no_default_policy = optional(bool)
    token_num_uses          = optional(number)
    token_type              = optional(string)
    namespace               = optional(string)
  }))
  default = {}
}

variable "spiffe_auth_backends" {
  description = "A map of SPIFFE auth backends to configure."
  type = map(object({
    path                            = optional(string, "spiffe")
    description                     = optional(string)
    trust_domain                    = string
    profile                         = string
    audience                        = optional(list(string))
    bundle                          = optional(string)
    endpoint_url                    = optional(string)
    endpoint_root_ca_truststore_pem = optional(string)
    endpoint_spiffe_id              = optional(string)
    namespace                       = optional(string)
    tune = optional(object({
      default_lease_ttl           = optional(string)
      max_lease_ttl               = optional(string)
      listing_visibility          = optional(string)
      passthrough_request_headers = optional(list(string))
      allowed_response_headers    = optional(list(string))
      token_type                  = optional(string)
    }))
  }))
  default = {}
}

variable "spiffe_auth_roles" {
  description = "A map of SPIFFE auth backend roles to configure."
  type = map(object({
    mount                   = string
    name                    = string
    workload_id_patterns    = list(string)
    display_name            = optional(string)
    alias_metadata          = optional(map(string))
    token_ttl               = optional(number)
    token_max_ttl           = optional(number)
    token_period            = optional(number)
    token_policies          = optional(list(string))
    token_bound_cidrs       = optional(list(string))
    token_explicit_max_ttl  = optional(number)
    token_no_default_policy = optional(bool)
    token_num_uses          = optional(number)
    token_type              = optional(string)
    namespace               = optional(string)
  }))
  default = {}
}

variable "oci_auth_backends" {
  description = "A map of OCI (Oracle Cloud Infrastructure) auth backends to configure."
  type = map(object({
    path            = optional(string, "oci")
    description     = optional(string)
    home_tenancy_id = string
    namespace       = optional(string)
    tune = optional(object({
      default_lease_ttl            = optional(string)
      max_lease_ttl                = optional(string)
      listing_visibility           = optional(string)
      audit_non_hmac_request_keys  = optional(list(string))
      audit_non_hmac_response_keys = optional(list(string))
      passthrough_request_headers  = optional(list(string))
      allowed_response_headers     = optional(list(string))
      token_type                   = optional(string)
    }))
  }))
  default = {}
}

variable "oci_auth_roles" {
  description = "A map of OCI auth backend roles to configure."
  type = map(object({
    name                    = string
    backend                 = string
    ocid_list               = list(string)
    token_ttl               = optional(number)
    token_max_ttl           = optional(number)
    token_period            = optional(number)
    token_policies          = optional(list(string))
    token_bound_cidrs       = optional(list(string))
    token_explicit_max_ttl  = optional(number)
    token_no_default_policy = optional(bool)
    token_num_uses          = optional(number)
    token_type              = optional(string)
    namespace               = optional(string)
  }))
  default = {}
}

variable "alicloud_auth_backends" {
  description = "A map of AliCloud auth backends to configure."
  type = map(object({
    path        = optional(string, "alicloud")
    description = optional(string)
    namespace   = optional(string)
    tune = optional(object({
      default_lease_ttl            = optional(string)
      max_lease_ttl                = optional(string)
      listing_visibility           = optional(string)
      audit_non_hmac_request_keys  = optional(list(string))
      audit_non_hmac_response_keys = optional(list(string))
      passthrough_request_headers  = optional(list(string))
      allowed_response_headers     = optional(list(string))
      token_type                   = optional(string)
    }))
  }))
  default = {}
}

variable "alicloud_auth_roles" {
  description = "A map of AliCloud auth backend roles to configure."
  type = map(object({
    role                    = string
    backend                 = optional(string, "alicloud")
    arn                     = string
    token_ttl               = optional(number)
    token_max_ttl           = optional(number)
    token_period            = optional(number)
    token_policies          = optional(list(string))
    token_bound_cidrs       = optional(list(string))
    token_explicit_max_ttl  = optional(number)
    token_no_default_policy = optional(bool)
    token_num_uses          = optional(number)
    token_type              = optional(string)
    namespace               = optional(string)
  }))
  default = {}
}

variable "approle_auth_role_secret_ids" {
  description = "A map of AppRole secret IDs to create."
  type = map(object({
    backend           = string
    role_name         = string
    metadata          = optional(string)
    cidr_list         = optional(list(string))
    token_bound_cidrs = optional(list(string))
    secret_id         = optional(string)
    wrapping_ttl      = optional(string)
    namespace         = optional(string)
  }))
  default = {}
}

variable "aws_auth_backend_logins" {
  description = "A map of AWS auth backend logins."
  type = map(object({
    backend                 = optional(string)
    role                    = optional(string)
    identity                = optional(string)
    signature               = optional(string)
    pkcs7                   = optional(string)
    nonce                   = optional(string)
    iam_http_request_method = optional(string)
    iam_request_url         = optional(string)
    iam_request_body        = optional(string)
    iam_request_headers     = optional(string)
    namespace               = optional(string)
  }))
  default = {}
}

variable "tokens" {
  description = "A map of Vault tokens to create."
  type = map(object({
    role_name         = optional(string)
    policies          = optional(list(string))
    no_parent         = optional(bool)
    no_default_policy = optional(bool)
    renewable         = optional(bool)
    ttl               = optional(string)
    explicit_max_ttl  = optional(string)
    display_name      = optional(string)
    num_uses          = optional(number)
    period            = optional(string)
    renew_min_lease   = optional(number)
    renew_increment   = optional(number)
    metadata          = optional(map(string))
    namespace         = optional(string)
  }))
  default = {}
}
