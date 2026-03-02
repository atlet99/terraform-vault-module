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
