###############################################################################
# Auth Backends
###############################################################################

resource "vault_auth_backend" "this" {
  for_each = var.auth_backends

  type            = each.value.type
  path            = each.value.path
  description     = each.value.description
  local           = each.value.local
  namespace       = each.value.namespace
  disable_remount = each.value.disable_remount

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

###############################################################################
# Kubernetes Auth Backends
###############################################################################

resource "vault_auth_backend" "kubernetes" {
  for_each = var.kubernetes_auth_backends

  type        = "kubernetes"
  path        = each.value.path
  description = each.value.description
  namespace   = each.value.namespace
}

resource "vault_kubernetes_auth_backend_config" "this" {
  for_each = var.kubernetes_auth_backends

  backend                           = vault_auth_backend.kubernetes[each.key].path
  namespace                         = each.value.namespace
  kubernetes_host                   = each.value.kubernetes_host
  kubernetes_ca_cert                = each.value.kubernetes_ca_cert
  token_reviewer_jwt                = each.value.token_reviewer_jwt
  issuer                            = each.value.issuer
  disable_iss_validation            = each.value.disable_iss_validation
  disable_local_ca_jwt              = each.value.disable_local_ca_jwt
  pem_keys                          = each.value.pem_keys
  use_annotations_as_alias_metadata = each.value.use_annotations_as_alias_metadata
  token_reviewer_jwt_wo             = each.value.token_reviewer_jwt_wo
  token_reviewer_jwt_wo_version     = each.value.token_reviewer_jwt_wo_version
}

locals {
  # Flatten kubernetes auth roles into a single map for for_each
  kubernetes_auth_roles = merge([
    for backend_key, backend in var.kubernetes_auth_backends : {
      for role_key, role in backend.roles :
      "${backend_key}/${role_key}" => merge(role, {
        backend_key = backend_key
        namespace   = backend.namespace
      })
    }
  ]...)
}

resource "vault_kubernetes_auth_backend_role" "this" {
  for_each = local.kubernetes_auth_roles

  backend                                  = vault_auth_backend.kubernetes[each.value.backend_key].path
  namespace                                = each.value.namespace
  role_name                                = each.value.role_name
  bound_service_account_names              = each.value.bound_service_account_names
  bound_service_account_namespaces         = each.value.bound_service_account_namespaces
  audience                                 = each.value.audience
  alias_name_source                        = each.value.alias_name_source
  token_ttl                                = each.value.token_ttl
  token_max_ttl                            = each.value.token_max_ttl
  token_period                             = each.value.token_period
  token_policies                           = each.value.token_policies
  token_bound_cidrs                        = each.value.token_bound_cidrs
  token_explicit_max_ttl                   = each.value.token_explicit_max_ttl
  token_no_default_policy                  = each.value.token_no_default_policy
  token_num_uses                           = each.value.token_num_uses
  token_type                               = each.value.token_type
  bound_service_account_namespace_selector = each.value.bound_service_account_namespace_selector
}

###############################################################################
# AppRole Auth Roles
###############################################################################

resource "vault_approle_auth_backend_role" "this" {
  for_each = var.approle_auth_roles

  role_name               = each.value.role_name
  backend                 = each.value.backend
  role_id                 = each.value.role_id
  bind_secret_id          = each.value.bind_secret_id
  secret_id_bound_cidrs   = each.value.secret_id_bound_cidrs
  secret_id_num_uses      = each.value.secret_id_num_uses
  secret_id_ttl           = each.value.secret_id_ttl
  local_secret_ids        = each.value.local_secret_ids
  token_ttl               = each.value.token_ttl
  token_max_ttl           = each.value.token_max_ttl
  token_period            = each.value.token_period
  token_policies          = each.value.token_policies
  token_bound_cidrs       = each.value.token_bound_cidrs
  token_explicit_max_ttl  = each.value.token_explicit_max_ttl
  token_no_default_policy = each.value.token_no_default_policy
  token_num_uses          = each.value.token_num_uses
  token_type              = each.value.token_type
  namespace               = each.value.namespace
}

###############################################################################
# JWT/OIDC Auth Roles
###############################################################################

resource "vault_jwt_auth_backend_role" "this" {
  for_each = var.jwt_oidc_auth_roles

  role_name                    = each.value.role_name
  backend                      = each.value.backend
  role_type                    = each.value.role_type
  bound_audiences              = each.value.bound_audiences
  user_claim                   = each.value.user_claim
  user_claim_json_pointer      = each.value.user_claim_json_pointer
  clock_skew_leeway            = each.value.clock_skew_leeway
  expiration_leeway            = each.value.expiration_leeway
  not_before_leeway            = each.value.not_before_leeway
  allowed_redirect_uris        = each.value.allowed_redirect_uris
  bound_subject                = each.value.bound_subject
  oidc_scopes                  = each.value.oidc_scopes
  bound_claims_type            = each.value.bound_claims_type
  bound_claims                 = each.value.bound_claims
  disable_bound_claims_parsing = each.value.disable_bound_claims_parsing
  claim_mappings               = each.value.claim_mappings
  groups_claim                 = each.value.groups_claim
  verbose_oidc_logging         = each.value.verbose_oidc_logging
  max_age                      = each.value.max_age
  token_ttl                    = each.value.token_ttl
  token_max_ttl                = each.value.token_max_ttl
  token_period                 = each.value.token_period
  token_policies               = each.value.token_policies
  token_bound_cidrs            = each.value.token_bound_cidrs
  token_explicit_max_ttl       = each.value.token_explicit_max_ttl
  token_no_default_policy      = each.value.token_no_default_policy
  token_num_uses               = each.value.token_num_uses
  token_type                   = each.value.token_type
  namespace                    = each.value.namespace
}

###############################################################################
# GitHub Auth Backend (Phase 3)
###############################################################################

resource "vault_github_auth_backend" "this" {
  for_each = var.github_auth_backends

  path            = each.value.path
  organization    = each.value.organization
  organization_id = each.value.organization_id
  base_url        = each.value.base_url
  description     = each.value.description
  namespace       = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl  = tune.value.default_lease_ttl
      max_lease_ttl      = tune.value.max_lease_ttl
      listing_visibility = tune.value.listing_visibility
      token_type         = tune.value.token_type
    }
  }
}

###############################################################################
# Token Auth Backend Roles (Phase 4)
###############################################################################

resource "vault_token_auth_backend_role" "this" {
  for_each = var.token_auth_backend_roles

  role_name                = each.value.role_name
  allowed_policies         = each.value.allowed_policies
  allowed_policies_glob    = each.value.allowed_policies_glob
  disallowed_policies      = each.value.disallowed_policies
  disallowed_policies_glob = each.value.disallowed_policies_glob
  orphan                   = each.value.orphan
  allowed_entity_aliases   = each.value.allowed_entity_aliases
  renewable                = each.value.renewable
  path_suffix              = each.value.path_suffix
  token_ttl                = each.value.token_ttl
  token_max_ttl            = each.value.token_max_ttl
  token_period             = each.value.token_period
  token_explicit_max_ttl   = each.value.token_explicit_max_ttl
  token_no_default_policy  = each.value.token_no_default_policy
  token_num_uses           = each.value.token_num_uses
  token_type               = each.value.token_type
  token_bound_cidrs        = each.value.token_bound_cidrs
  namespace                = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# AWS Auth Backend (Phase 6)
###############################################################################

resource "vault_auth_backend" "aws" {
  for_each = var.aws_auth_backends

  type        = "aws"
  path        = each.value.path
  description = each.value.description
  namespace   = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

resource "vault_aws_auth_backend_client" "this" {
  for_each = var.aws_auth_backends

  backend                    = vault_auth_backend.aws[each.key].path
  access_key                 = each.value.access_key
  secret_key                 = each.value.secret_key
  ec2_endpoint               = each.value.ec2_endpoint
  iam_endpoint               = each.value.iam_endpoint
  sts_endpoint               = each.value.sts_endpoint
  sts_region                 = each.value.sts_region
  allowed_sts_header_values  = each.value.allowed_sts_header_values
  iam_server_id_header_value = each.value.iam_server_id_header_value
  role_arn                   = each.value.role_arn
  identity_token_audience    = each.value.identity_token_audience
  max_retries                = each.value.max_retries
}

resource "vault_aws_auth_backend_role" "this" {
  for_each = var.aws_auth_roles

  role                            = each.value.role
  backend                         = each.value.backend
  auth_type                       = each.value.auth_type
  bound_ami_ids                   = each.value.bound_ami_ids
  bound_account_ids               = each.value.bound_account_ids
  bound_regions                   = each.value.bound_regions
  bound_vpc_ids                   = each.value.bound_vpc_ids
  bound_subnet_ids                = each.value.bound_subnet_ids
  bound_iam_role_arns             = each.value.bound_iam_role_arns
  bound_iam_instance_profile_arns = each.value.bound_iam_instance_profile_arns
  bound_ec2_instance_ids          = each.value.bound_ec2_instance_ids
  role_tag                        = each.value.role_tag
  bound_iam_principal_arns        = each.value.bound_iam_principal_arns
  inferred_entity_type            = each.value.inferred_entity_type
  inferred_aws_region             = each.value.inferred_aws_region
  resolve_aws_unique_ids          = each.value.resolve_aws_unique_ids
  allow_instance_migration        = each.value.allow_instance_migration
  disallow_reauthentication       = each.value.disallow_reauthentication
  token_ttl                       = each.value.token_ttl
  token_max_ttl                   = each.value.token_max_ttl
  token_period                    = each.value.token_period
  token_policies                  = each.value.token_policies
  token_bound_cidrs               = each.value.token_bound_cidrs
  token_explicit_max_ttl          = each.value.token_explicit_max_ttl
  token_no_default_policy         = each.value.token_no_default_policy
  token_num_uses                  = each.value.token_num_uses
  token_type                      = each.value.token_type
}

###############################################################################
# Azure Auth Backend (Phase 6)
###############################################################################

resource "vault_auth_backend" "azure" {
  for_each = var.azure_auth_backends

  type        = "azure"
  path        = each.value.path
  description = each.value.description
  namespace   = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

resource "vault_azure_auth_backend_config" "this" {
  for_each = var.azure_auth_backends

  backend       = vault_auth_backend.azure[each.key].path
  tenant_id     = each.value.tenant_id
  client_id     = each.value.client_id
  client_secret = each.value.client_secret
  resource      = each.value.resource
  environment   = each.value.environment
}

resource "vault_azure_auth_backend_role" "this" {
  for_each = var.azure_auth_roles

  role                        = each.value.role
  backend                     = each.value.backend
  bound_service_principal_ids = each.value.bound_service_principal_ids
  bound_group_ids             = each.value.bound_group_ids
  bound_locations             = each.value.bound_locations
  bound_subscription_ids      = each.value.bound_subscription_ids
  bound_resource_groups       = each.value.bound_resource_groups
  bound_scale_sets            = each.value.bound_scale_sets
  token_ttl                   = each.value.token_ttl
  token_max_ttl               = each.value.token_max_ttl
  token_period                = each.value.token_period
  token_policies              = each.value.token_policies
  token_bound_cidrs           = each.value.token_bound_cidrs
  token_explicit_max_ttl      = each.value.token_explicit_max_ttl
  token_no_default_policy     = each.value.token_no_default_policy
  token_num_uses              = each.value.token_num_uses
  token_type                  = each.value.token_type
}

###############################################################################
# GCP Auth Backend (Phase 6)
###############################################################################

resource "vault_gcp_auth_backend" "this" {
  for_each = var.gcp_auth_backends

  path                    = each.value.path
  description             = each.value.description
  local                   = each.value.local
  credentials             = each.value.credentials
  client_email            = each.value.client_email
  project_id              = each.value.project_id
  identity_token_audience = each.value.identity_token_audience
  identity_token_ttl      = each.value.identity_token_ttl
  identity_token_key      = each.value.identity_token_key
  service_account_email   = each.value.service_account_email
  iam_alias               = each.value.iam_alias
  iam_metadata            = each.value.iam_metadata
  gce_alias               = each.value.gce_alias
  gce_metadata            = each.value.gce_metadata

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

resource "vault_gcp_auth_backend_role" "this" {
  for_each = var.gcp_auth_roles

  role                    = each.value.role
  backend                 = each.value.backend
  type                    = each.value.type
  bound_projects          = each.value.bound_projects
  add_group_aliases       = each.value.add_group_aliases
  max_jwt_exp             = each.value.max_jwt_exp
  allow_gce_inference     = each.value.allow_gce_inference
  bound_service_accounts  = each.value.bound_service_accounts
  bound_zones             = each.value.bound_zones
  bound_regions           = each.value.bound_regions
  bound_instance_groups   = each.value.bound_instance_groups
  bound_labels            = each.value.bound_labels
  token_ttl               = each.value.token_ttl
  token_max_ttl           = each.value.token_max_ttl
  token_period            = each.value.token_period
  token_policies          = each.value.token_policies
  token_bound_cidrs       = each.value.token_bound_cidrs
  token_explicit_max_ttl  = each.value.token_explicit_max_ttl
  token_no_default_policy = each.value.token_no_default_policy
  token_num_uses          = each.value.token_num_uses
  token_type              = each.value.token_type
}

###############################################################################
# LDAP Auth Backend (Phase 6)
###############################################################################

resource "vault_ldap_auth_backend" "this" {
  for_each = var.ldap_auth_backends

  path                        = each.value.path
  description                 = each.value.description
  local                       = each.value.local
  url                         = each.value.url
  starttls                    = each.value.starttls
  tls_min_version             = each.value.tls_min_version
  tls_max_version             = each.value.tls_max_version
  insecure_tls                = each.value.insecure_tls
  certificate                 = each.value.certificate
  binddn                      = each.value.binddn
  bindpass                    = each.value.bindpass
  case_sensitive_names        = each.value.case_sensitive_names
  max_page_size               = each.value.max_page_size
  userdn                      = each.value.userdn
  userattr                    = each.value.userattr
  userfilter                  = each.value.userfilter
  discoverdn                  = each.value.discoverdn
  deny_null_bind              = each.value.deny_null_bind
  upndomain                   = each.value.upndomain
  groupfilter                 = each.value.groupfilter
  groupdn                     = each.value.groupdn
  groupattr                   = each.value.groupattr
  username_as_alias           = each.value.username_as_alias
  use_token_groups            = each.value.use_token_groups
  client_tls_cert             = each.value.client_tls_cert
  client_tls_key              = each.value.client_tls_key
  connection_timeout          = each.value.connection_timeout
  request_timeout             = each.value.request_timeout
  dereference_aliases         = each.value.dereference_aliases
  enable_samaccountname_login = each.value.enable_samaccountname_login
  anonymous_group_search      = each.value.anonymous_group_search

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

resource "vault_ldap_auth_backend_group" "this" {
  for_each = var.ldap_auth_groups

  groupname = each.value.groupname
  backend   = each.value.backend
  policies  = each.value.policies
}

###############################################################################
# Okta Auth Backend (Phase 6)
###############################################################################

resource "vault_okta_auth_backend" "this" {
  for_each = var.okta_auth_backends

  path            = each.value.path
  description     = each.value.description
  organization    = each.value.organization
  token           = each.value.token
  base_url        = each.value.base_url
  bypass_okta_mfa = each.value.bypass_okta_mfa

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

resource "vault_okta_auth_backend_group" "this" {
  for_each = var.okta_auth_groups

  group_name = each.value.group_name
  path       = each.value.path
  policies   = each.value.policies
}

resource "vault_okta_auth_backend_user" "this" {
  for_each = var.okta_auth_users

  username = each.value.username
  path     = each.value.path
  groups   = each.value.groups
  policies = each.value.policies
}

###############################################################################
# Cert Auth Backend (Phase 6)
###############################################################################

resource "vault_auth_backend" "cert" {
  for_each = var.cert_auth_backends

  type        = "cert"
  path        = each.value.path
  description = each.value.description
  namespace   = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

resource "vault_cert_auth_backend_role" "this" {
  for_each = var.cert_auth_roles

  name                         = each.value.name
  backend                      = each.value.backend
  certificate                  = each.value.certificate
  allowed_names                = each.value.allowed_names
  allowed_common_names         = each.value.allowed_common_names
  allowed_dns_sans             = each.value.allowed_dns_sans
  allowed_email_sans           = each.value.allowed_email_sans
  allowed_uri_sans             = each.value.allowed_uri_sans
  allowed_organizational_units = each.value.allowed_organizational_units
  required_extensions          = each.value.required_extensions
  display_name                 = each.value.display_name
  ocsp_ca_certificates         = each.value.ocsp_ca_certificates
  ocsp_servers_override        = each.value.ocsp_servers_override
  ocsp_enabled                 = each.value.ocsp_enabled
  ocsp_fail_open               = each.value.ocsp_fail_open
  ocsp_query_all_servers       = each.value.ocsp_query_all_servers
  ocsp_max_retries             = each.value.ocsp_max_retries
  ocsp_this_update_max_age     = each.value.ocsp_this_update_max_age
  token_ttl                    = each.value.token_ttl
  token_max_ttl                = each.value.token_max_ttl
  token_period                 = each.value.token_period
  token_policies               = each.value.token_policies
  token_bound_cidrs            = each.value.token_bound_cidrs
  token_explicit_max_ttl       = each.value.token_explicit_max_ttl
  token_no_default_policy      = each.value.token_no_default_policy
  token_num_uses               = each.value.token_num_uses
  token_type                   = each.value.token_type
}

###############################################################################
# SAML Auth Backend
###############################################################################

resource "vault_saml_auth_backend" "this" {
  for_each = var.saml_auth_backends

  path                         = each.value.path
  idp_metadata_url             = each.value.idp_metadata_url
  idp_sso_url                  = each.value.idp_sso_url
  idp_entity_id                = each.value.idp_entity_id
  idp_cert                     = each.value.idp_cert
  entity_id                    = each.value.entity_id
  acs_urls                     = each.value.acs_urls
  default_role                 = each.value.default_role
  verbose_logging              = each.value.verbose_logging
  validate_assertion_signature = each.value.validate_assertion_signature
  validate_response_signature  = each.value.validate_response_signature
  disable_remount              = each.value.disable_remount
  namespace                    = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

resource "vault_saml_auth_backend_role" "this" {
  for_each = var.saml_auth_roles

  path                    = each.value.path
  name                    = each.value.name
  groups_attribute        = each.value.groups_attribute
  bound_subjects          = each.value.bound_subjects
  bound_subjects_type     = each.value.bound_subjects_type
  bound_attributes        = each.value.bound_attributes
  bound_attributes_type   = each.value.bound_attributes_type
  token_ttl               = each.value.token_ttl
  token_max_ttl           = each.value.token_max_ttl
  token_period            = each.value.token_period
  token_policies          = each.value.token_policies
  token_bound_cidrs       = each.value.token_bound_cidrs
  token_explicit_max_ttl  = each.value.token_explicit_max_ttl
  token_no_default_policy = each.value.token_no_default_policy
  token_num_uses          = each.value.token_num_uses
  token_type              = each.value.token_type
  namespace               = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# SPIFFE Auth Backend
###############################################################################

resource "vault_auth_backend" "spiffe" {
  for_each = var.spiffe_auth_backends

  type        = "spiffe"
  path        = each.value.path
  description = each.value.description
  namespace   = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl           = tune.value.default_lease_ttl
      max_lease_ttl               = tune.value.max_lease_ttl
      listing_visibility          = tune.value.listing_visibility
      passthrough_request_headers = tune.value.passthrough_request_headers
      allowed_response_headers    = tune.value.allowed_response_headers
      token_type                  = tune.value.token_type
    }
  }
}

resource "vault_spiffe_auth_backend_config" "this" {
  for_each = var.spiffe_auth_backends

  mount                           = vault_auth_backend.spiffe[each.key].path
  trust_domain                    = each.value.trust_domain
  profile                         = each.value.profile
  audience                        = each.value.audience
  defer_bundle_fetch              = each.value.defer_bundle_fetch
  bundle                          = each.value.bundle
  endpoint_url                    = each.value.endpoint_url
  endpoint_root_ca_truststore_pem = each.value.endpoint_root_ca_truststore_pem
  endpoint_spiffe_id              = each.value.endpoint_spiffe_id
  namespace                       = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_spiffe_auth_backend_role" "this" {
  for_each = var.spiffe_auth_roles

  mount                   = each.value.mount
  name                    = each.value.name
  workload_id_patterns    = each.value.workload_id_patterns
  display_name            = each.value.display_name
  alias_metadata          = each.value.alias_metadata
  token_ttl               = each.value.token_ttl
  token_max_ttl           = each.value.token_max_ttl
  token_period            = each.value.token_period
  token_policies          = each.value.token_policies
  token_bound_cidrs       = each.value.token_bound_cidrs
  token_explicit_max_ttl  = each.value.token_explicit_max_ttl
  token_no_default_policy = each.value.token_no_default_policy
  token_num_uses          = each.value.token_num_uses
  token_type              = each.value.token_type
  namespace               = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# OCI Auth Backend
###############################################################################

resource "vault_auth_backend" "oci" {
  for_each = var.oci_auth_backends

  type        = "oci"
  path        = each.value.path
  description = each.value.description
  namespace   = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

resource "vault_oci_auth_backend" "this" {
  for_each = var.oci_auth_backends

  path            = vault_auth_backend.oci[each.key].path
  home_tenancy_id = each.value.home_tenancy_id
  namespace       = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_oci_auth_backend_role" "this" {
  for_each = var.oci_auth_roles

  name                    = each.value.name
  backend                 = each.value.backend
  ocid_list               = each.value.ocid_list
  token_ttl               = each.value.token_ttl
  token_max_ttl           = each.value.token_max_ttl
  token_period            = each.value.token_period
  token_policies          = each.value.token_policies
  token_bound_cidrs       = each.value.token_bound_cidrs
  token_explicit_max_ttl  = each.value.token_explicit_max_ttl
  token_no_default_policy = each.value.token_no_default_policy
  token_num_uses          = each.value.token_num_uses
  token_type              = each.value.token_type
  namespace               = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# AliCloud Auth Backend
###############################################################################

resource "vault_auth_backend" "alicloud" {
  for_each = var.alicloud_auth_backends

  type        = "alicloud"
  path        = each.value.path
  description = each.value.description
  namespace   = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "tune" {
    for_each = each.value.tune != null ? [each.value.tune] : []
    content {
      default_lease_ttl            = tune.value.default_lease_ttl
      max_lease_ttl                = tune.value.max_lease_ttl
      listing_visibility           = tune.value.listing_visibility
      audit_non_hmac_request_keys  = tune.value.audit_non_hmac_request_keys
      audit_non_hmac_response_keys = tune.value.audit_non_hmac_response_keys
      passthrough_request_headers  = tune.value.passthrough_request_headers
      allowed_response_headers     = tune.value.allowed_response_headers
      token_type                   = tune.value.token_type
    }
  }
}

resource "vault_alicloud_auth_backend_role" "this" {
  for_each = var.alicloud_auth_roles

  role                    = each.value.role
  backend                 = each.value.backend
  arn                     = each.value.arn
  token_ttl               = each.value.token_ttl
  token_max_ttl           = each.value.token_max_ttl
  token_period            = each.value.token_period
  token_policies          = each.value.token_policies
  token_bound_cidrs       = each.value.token_bound_cidrs
  token_explicit_max_ttl  = each.value.token_explicit_max_ttl
  token_no_default_policy = each.value.token_no_default_policy
  token_num_uses          = each.value.token_num_uses
  token_type              = each.value.token_type
  namespace               = each.value.namespace != null ? each.value.namespace : var.namespace
}
