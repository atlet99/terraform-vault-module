###############################################################################
# Database Secret Backend (Phase 3)
###############################################################################

resource "vault_database_secret_backend_connection" "this" {
  for_each = var.database_connections

  name              = each.value.name
  backend           = each.value.backend
  allowed_roles     = each.value.allowed_roles
  plugin_name       = each.value.plugin_name
  verify_connection = each.value.verify_connection
  namespace         = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "postgresql" {
    for_each = each.value.postgresql != null ? [each.value.postgresql] : []
    content {
      max_open_connections    = postgresql.value.max_open_connections
      max_idle_connections    = postgresql.value.max_idle_connections
      max_connection_lifetime = postgresql.value.max_connection_lifetime
      username_template       = postgresql.value.username_template
    }
  }

  dynamic "mysql" {
    for_each = each.value.mysql != null ? [each.value.mysql] : []
    content {
      connection_url          = mysql.value.connection_url
      max_open_connections    = mysql.value.max_open_connections
      max_idle_connections    = mysql.value.max_idle_connections
      max_connection_lifetime = mysql.value.max_connection_lifetime
      username_template       = mysql.value.username_template
    }
  }
}

resource "vault_database_secret_backend_role" "this" {
  for_each = var.database_roles

  name                  = each.value.name
  backend               = each.value.backend
  db_name               = each.value.db_name
  creation_statements   = each.value.creation_statements
  revocation_statements = each.value.revocation_statements
  default_ttl           = each.value.default_ttl
  max_ttl               = each.value.max_ttl
  namespace             = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_database_secret_backend_static_role" "this" {
  for_each = var.database_static_roles

  name                = each.value.name
  backend             = each.value.backend
  db_name             = each.value.db_name
  username            = each.value.username
  rotation_period     = each.value.rotation_period
  rotation_window     = each.value.rotation_window
  rotation_statements = each.value.rotation_statements
  namespace           = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# PKI Secret Backend (Phase 3)
###############################################################################

resource "vault_pki_secret_backend_role" "this" {
  for_each = var.pki_roles

  name               = each.value.name
  backend            = each.value.backend
  ttl                = each.value.ttl
  max_ttl            = each.value.max_ttl
  allow_localhost    = each.value.allow_localhost
  allowed_domains    = each.value.allowed_domains
  allow_bare_domains = each.value.allow_bare_domains
  allow_subdomains   = each.value.allow_subdomains
  allow_any_name     = each.value.allow_any_name
  enforce_hostnames  = each.value.enforce_hostnames
  allow_ip_sans      = each.value.allow_ip_sans
  server_flag        = each.value.server_flag
  client_flag        = each.value.client_flag
  key_type           = each.value.key_type
  key_bits           = each.value.key_bits
  no_store           = each.value.no_store
  namespace          = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# AWS Secret Backend (Phase 3)
###############################################################################

resource "vault_aws_secret_backend_role" "this" {
  for_each = var.aws_roles

  name            = each.value.name
  backend         = each.value.backend
  credential_type = each.value.credential_type
  policy_arns     = each.value.policy_arns
  policy_document = each.value.policy_document
  role_arns       = each.value.role_arns
  default_sts_ttl = each.value.default_sts_ttl
  max_sts_ttl     = each.value.max_sts_ttl
  iam_groups      = each.value.iam_groups
  namespace       = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# SSH Secret Backend (Phase 4)
###############################################################################

resource "vault_ssh_secret_backend_role" "this" {
  for_each = var.ssh_roles

  name                     = each.value.name
  backend                  = each.value.backend
  key_type                 = each.value.key_type
  allow_bare_domains       = each.value.allow_bare_domains
  allow_host_certificates  = each.value.allow_host_certificates
  allow_subdomains         = each.value.allow_subdomains
  allow_user_certificates  = each.value.allow_user_certificates
  allow_user_key_ids       = each.value.allow_user_key_ids
  allowed_critical_options = each.value.allowed_critical_options
  allowed_domains_template = each.value.allowed_domains_template
  allowed_domains          = each.value.allowed_domains
  cidr_list                = each.value.cidr_list
  allowed_extensions       = each.value.allowed_extensions
  default_extensions       = each.value.default_extensions
  default_critical_options = each.value.default_critical_options
  allowed_users_template   = each.value.allowed_users_template
  allowed_users            = each.value.allowed_users
  default_user             = each.value.default_user
  default_user_template    = each.value.default_user_template
  key_id_format            = each.value.key_id_format
  algorithm_signer         = each.value.algorithm_signer
  max_ttl                  = each.value.max_ttl
  ttl                      = each.value.ttl
  not_before_duration      = each.value.not_before_duration
  allow_empty_principals   = each.value.allow_empty_principals
  namespace                = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "allowed_user_key_config" {
    for_each = each.value.allowed_user_key_config != null ? each.value.allowed_user_key_config : []
    content {
      type    = allowed_user_key_config.value.type
      lengths = allowed_user_key_config.value.lengths
    }
  }
}

###############################################################################
# Transit Keys
###############################################################################

resource "vault_transit_secret_backend_key" "this" {
  for_each = var.transit_keys

  name                   = each.value.name
  backend                = each.value.backend
  type                   = each.value.type
  deletion_allowed       = each.value.deletion_allowed
  derived                = each.value.derived
  exportable             = each.value.exportable
  allow_plaintext_backup = each.value.allow_plaintext_backup
  auto_rotate_period     = each.value.auto_rotate_period
  min_decryption_version = each.value.min_decryption_version
  min_encryption_version = each.value.min_encryption_version
  context                = each.value.context
  key_size               = each.value.key_size
  namespace              = each.value.namespace
}

###############################################################################
# KV-V2 Backend Configuration
###############################################################################

resource "vault_kv_secret_backend_v2" "this" {
  for_each = var.kv_secret_backend_v2_config

  mount                = each.value.mount
  namespace            = each.value.namespace
  max_versions         = each.value.max_versions
  cas_required         = each.value.cas_required
  delete_version_after = each.value.delete_version_after
}

###############################################################################
# KV-V2 Secrets
###############################################################################

resource "vault_kv_secret_v2" "this" {
  for_each = var.kv_secrets_v2

  mount               = each.value.mount
  name                = each.value.name
  namespace           = each.value.namespace
  cas                 = each.value.cas
  disable_read        = each.value.disable_read
  delete_all_versions = each.value.delete_all_versions
  data_json           = each.value.data_json

  dynamic "custom_metadata" {
    for_each = each.value.custom_metadata != null ? [each.value.custom_metadata] : []
    content {
      max_versions         = custom_metadata.value.max_versions
      cas_required         = custom_metadata.value.cas_required
      delete_version_after = custom_metadata.value.delete_version_after
      data                 = custom_metadata.value.data
    }
  }
}

###############################################################################
# Azure Secret Backend (Phase 5)
###############################################################################

resource "vault_azure_secret_backend" "this" {
  for_each = var.azure_secret_backends

  path            = each.value.path
  description     = each.value.description
  subscription_id = each.value.subscription_id
  tenant_id       = each.value.tenant_id
  client_id       = each.value.client_id
  client_secret   = each.value.client_secret
  environment     = each.value.environment
  namespace       = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_azure_secret_backend_role" "this" {
  for_each = var.azure_secret_backend_roles

  role                  = each.value.role
  backend               = each.value.backend
  application_object_id = each.value.application_object_id
  ttl                   = each.value.ttl
  max_ttl               = each.value.max_ttl
  permanently_delete    = each.value.permanently_delete
  namespace             = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "azure_roles" {
    for_each = each.value.azure_roles != null ? each.value.azure_roles : []
    content {
      role_name = azure_roles.value.role_name
      scope     = azure_roles.value.scope
    }
  }

  dynamic "azure_groups" {
    for_each = each.value.azure_groups != null ? each.value.azure_groups : []
    content {
      group_name = azure_groups.value.group_name
    }
  }
}

###############################################################################
# GCP Secret Backend (Phase 5)
###############################################################################

resource "vault_gcp_secret_backend" "this" {
  for_each = var.gcp_secret_backends

  path                      = each.value.path
  description               = each.value.description
  credentials               = each.value.credentials
  default_lease_ttl_seconds = each.value.default_lease_ttl_seconds
  max_lease_ttl_seconds     = each.value.max_lease_ttl_seconds
  namespace                 = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_gcp_secret_roleset" "this" {
  for_each = var.gcp_secret_backend_rolesets

  roleset      = each.value.roleset
  backend      = each.value.backend
  project      = each.value.project
  secret_type  = each.value.secret_type
  token_scopes = each.value.token_scopes
  namespace    = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "binding" {
    for_each = each.value.bindings
    content {
      resource = binding.value.resource
      roles    = binding.value.roles
    }
  }
}

resource "vault_gcp_secret_static_account" "this" {
  for_each = var.gcp_secret_backend_static_accounts

  static_account        = each.value.static_account
  backend               = each.value.backend
  service_account_email = each.value.service_account_email
  secret_type           = each.value.secret_type
  token_scopes          = each.value.token_scopes
  namespace             = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "binding" {
    for_each = each.value.bindings != null ? each.value.bindings : []
    content {
      resource = binding.value.resource
      roles    = binding.value.roles
    }
  }
}

###############################################################################
# LDAP Secret Backend (Phase 5 - supersedes AD)
###############################################################################

resource "vault_ldap_secret_backend" "this" {
  for_each = var.ldap_secret_backends

  path                = each.value.path
  description         = each.value.description
  binddn              = each.value.binddn
  bindpass            = each.value.bindpass
  bindpass_wo         = each.value.bindpass_wo
  bindpass_wo_version = each.value.bindpass_wo_version
  url                 = each.value.url
  userdn              = each.value.userdn
  userattr            = each.value.userattr
  upndomain           = each.value.upndomain
  insecure_tls        = each.value.insecure_tls
  starttls            = each.value.starttls
  certificate         = each.value.certificate
  client_tls_cert     = each.value.client_tls_cert
  client_tls_key      = each.value.client_tls_key
  password_policy     = each.value.password_policy
  schema              = each.value.schema
  connection_timeout  = each.value.connection_timeout
  request_timeout     = each.value.request_timeout
  credential_type     = each.value.credential_type
  namespace           = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_ldap_secret_backend_library_set" "this" {
  for_each = var.ldap_secret_backend_library_sets

  name                         = each.value.name
  mount                        = each.value.mount
  service_account_names        = each.value.service_account_names
  ttl                          = each.value.ttl
  max_ttl                      = each.value.max_ttl
  disable_check_in_enforcement = each.value.disable_check_in_enforcement
  namespace                    = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_ldap_secret_backend_static_role" "this" {
  for_each = var.ldap_secret_backend_static_roles

  role_name            = each.value.role_name
  mount                = each.value.mount
  username             = each.value.username
  dn                   = each.value.dn
  rotation_period      = each.value.rotation_period
  skip_import_rotation = each.value.skip_import_rotation
  namespace            = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# PKI ACME support (Phase 5)
###############################################################################

resource "vault_pki_secret_backend_config_acme" "this" {
  for_each = var.pki_secret_backend_config_acmes

  backend                  = each.value.backend
  enabled                  = each.value.enabled
  default_directory_policy = each.value.default_directory_policy
  allowed_roles            = each.value.allowed_roles
  allow_role_ext_key_usage = each.value.allow_role_ext_key_usage
  allowed_issuers          = each.value.allowed_issuers
  eab_policy               = each.value.eab_policy
  dns_resolver             = each.value.dns_resolver
  max_ttl                  = each.value.max_ttl
  namespace                = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_pki_secret_backend_acme_eab" "this" {
  for_each = var.pki_secret_backend_acme_eabs

  backend   = each.value.backend
  issuer    = each.value.issuer
  role      = each.value.role
  namespace = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# Consul Secret Backend
###############################################################################

resource "vault_consul_secret_backend" "this" {
  for_each = var.consul_secret_backends

  path                      = each.value.path
  description               = each.value.description
  address                   = each.value.address
  scheme                    = each.value.scheme
  token                     = each.value.token
  default_lease_ttl_seconds = each.value.default_lease_ttl_seconds
  max_lease_ttl_seconds     = each.value.max_lease_ttl_seconds
  namespace                 = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_consul_secret_backend_role" "this" {
  for_each = var.consul_secret_roles

  name               = each.value.name
  backend            = each.value.backend
  policies           = each.value.policies
  consul_namespace   = each.value.consul_namespace
  consul_roles       = each.value.consul_roles
  partition          = each.value.partition
  node_identities    = each.value.node_identities
  service_identities = each.value.service_identities
  ttl                = each.value.ttl
  max_ttl            = each.value.max_ttl
  namespace          = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# Nomad Secret Backend
###############################################################################

resource "vault_nomad_secret_backend" "this" {
  for_each = var.nomad_secret_backends

  backend                   = each.value.path
  description               = each.value.description
  address                   = each.value.address
  token                     = each.value.token
  max_token_name_length     = each.value.max_token_name_length
  default_lease_ttl_seconds = each.value.default_lease_ttl_seconds
  max_lease_ttl_seconds     = each.value.max_lease_ttl_seconds
  namespace                 = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_nomad_secret_role" "this" {
  for_each = var.nomad_secret_roles

  role      = each.value.role
  backend   = each.value.backend
  policies  = each.value.policies
  global    = each.value.global
  type      = each.value.type
  namespace = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# MongoDB Atlas Secret Backend
###############################################################################

resource "vault_mongodbatlas_secret_backend" "this" {
  for_each = var.mongodbatlas_secret_backends

  mount       = each.value.path
  private_key = each.value.private_key
  public_key  = each.value.public_key
  namespace   = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_mongodbatlas_secret_role" "this" {
  for_each = var.mongodbatlas_secret_roles

  name            = each.value.name
  mount           = each.value.mount
  organization_id = each.value.organization_id
  project_id      = each.value.project_id
  roles           = each.value.roles
  project_roles   = each.value.project_roles
  ip_addresses    = each.value.ip_addresses
  cidr_blocks     = each.value.cidr_blocks
  ttl             = each.value.ttl
  max_ttl         = each.value.max_ttl
  namespace       = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# RabbitMQ Secret Backend
###############################################################################

resource "vault_rabbitmq_secret_backend" "this" {
  for_each = var.rabbitmq_secret_backends

  path              = each.value.path
  description       = each.value.description
  connection_uri    = each.value.connection_uri
  username          = each.value.username
  password          = each.value.password
  verify_connection = each.value.verify_connection
  namespace         = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_rabbitmq_secret_backend_role" "this" {
  for_each = var.rabbitmq_secret_roles

  name      = each.value.name
  backend   = each.value.backend
  tags      = each.value.tags
  namespace = each.value.namespace != null ? each.value.namespace : var.namespace

  dynamic "vhost" {
    for_each = each.value.vhost != null ? each.value.vhost : {}
    content {
      host      = vhost.key
      configure = vhost.value.configure
      read      = vhost.value.read
      write     = vhost.value.write
    }
  }

  dynamic "vhost_topic" {
    for_each = each.value.vhost_topics != null ? each.value.vhost_topics : {}
    content {
      host = vhost_topic.key
      dynamic "vhost" {
        for_each = vhost_topic.value
        content {
          topic = vhost.key
          read  = vhost.value.read
          write = vhost.value.write
        }
      }
    }
  }
}

###############################################################################
# Terraform Cloud Secret Backend
###############################################################################

resource "vault_terraform_cloud_secret_backend" "this" {
  for_each = var.terraform_cloud_secret_backends

  backend     = each.value.path
  description = each.value.description
  token       = each.value.token
  address     = each.value.address
  base_path   = each.value.base_path
  namespace   = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_terraform_cloud_secret_role" "this" {
  for_each = var.terraform_cloud_secret_roles

  name         = each.value.name
  backend      = each.value.backend
  organization = each.value.organization
  team_id      = each.value.team_id
  user_id      = each.value.user_id
  ttl          = each.value.ttl
  max_ttl      = each.value.max_ttl
  namespace    = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# KMIP Secret Backend
###############################################################################

resource "vault_kmip_secret_backend" "this" {
  for_each = var.kmip_secret_backends

  path                        = each.value.path
  description                 = each.value.description
  listen_addrs                = each.value.listen_addrs
  tls_ca_key_type             = each.value.tls_ca_key_type
  tls_ca_key_bits             = each.value.tls_ca_key_bits
  tls_min_version             = each.value.tls_min_version
  server_hostnames            = each.value.server_hostnames
  server_ips                  = each.value.server_ips
  default_tls_client_key_type = each.value.default_tls_client_key_type
  default_tls_client_key_bits = each.value.default_tls_client_key_bits
  default_tls_client_ttl      = each.value.default_tls_client_ttl
  namespace                   = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_kmip_secret_role" "this" {
  for_each = var.kmip_secret_roles

  role                        = each.value.role
  path                        = each.value.path
  scope                       = each.value.scope
  tls_client_key_type         = each.value.tls_client_key_type
  tls_client_key_bits         = each.value.tls_client_key_bits
  tls_client_ttl              = each.value.tls_client_ttl
  operation_all               = each.value.operation_all
  operation_activate          = each.value.operation_activate
  operation_create            = each.value.operation_create
  operation_get               = each.value.operation_get
  operation_get_attributes    = each.value.operation_get_attributes
  operation_destroy           = each.value.operation_destroy
  operation_discover_versions = each.value.operation_discover_versions
  operation_register          = each.value.operation_register
  operation_revoke            = each.value.operation_revoke
  namespace                   = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_kmip_secret_scope" "this" {
  for_each = var.kmip_secret_scopes

  scope     = each.value.scope
  path      = each.value.path
  force     = each.value.force
  namespace = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# Transform Engine
###############################################################################

resource "vault_transform_alphabet" "this" {
  for_each = var.transform_alphabets

  name      = each.value.name
  path      = each.value.path
  alphabet  = each.value.alphabet
  namespace = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_transform_template" "this" {
  for_each = var.transform_templates

  name           = each.value.name
  path           = each.value.path
  type           = each.value.type
  pattern        = each.value.pattern
  alphabet       = each.value.alphabet
  encode_format  = each.value.encode_format
  decode_formats = each.value.decode_formats
  namespace      = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_transform_transformation" "this" {
  for_each = var.transform_transformations

  name              = each.value.name
  path              = each.value.path
  type              = each.value.type
  template          = each.value.template
  tweak_source      = each.value.tweak_source
  masking_character = each.value.masking_character
  allowed_roles     = each.value.allowed_roles
  namespace         = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_transform_role" "this" {
  for_each = var.transform_roles

  name            = each.value.name
  path            = each.value.path
  transformations = each.value.transformations
  namespace       = each.value.namespace != null ? each.value.namespace : var.namespace
}
