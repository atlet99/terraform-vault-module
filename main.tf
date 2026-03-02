###############################################################################
# Secrets Engine Mounts
###############################################################################

resource "vault_mount" "this" {
  for_each = var.mounts

  path                         = each.value.path
  type                         = each.value.type
  description                  = each.value.description
  default_lease_ttl_seconds    = each.value.default_lease_ttl_seconds
  max_lease_ttl_seconds        = each.value.max_lease_ttl_seconds
  local                        = each.value.local
  seal_wrap                    = each.value.seal_wrap
  external_entropy_access      = each.value.external_entropy_access
  namespace                    = each.value.namespace
  options                      = each.value.options
  listing_visibility           = each.value.listing_visibility
  allowed_managed_keys         = each.value.allowed_managed_keys
  audit_non_hmac_request_keys  = each.value.audit_non_hmac_request_keys
  audit_non_hmac_response_keys = each.value.audit_non_hmac_response_keys
  passthrough_request_headers  = each.value.passthrough_request_headers
  allowed_response_headers     = each.value.allowed_response_headers
  delegated_auth_accessors     = each.value.delegated_auth_accessors
  plugin_version               = each.value.plugin_version
  identity_token_key           = each.value.identity_token_key
  force_no_cache               = each.value.force_no_cache
}

###############################################################################
# Namespaces (Vault Enterprise)
###############################################################################

resource "vault_namespace" "this" {
  for_each = var.namespaces

  path            = each.value.path
  namespace       = each.value.namespace
  custom_metadata = each.value.custom_metadata
}

###############################################################################
# Raft Storage Management (Vault Enterprise / Raft Storage)
###############################################################################

resource "vault_raft_autopilot" "this" {
  count = var.raft_autopilot != null ? 1 : 0

  cleanup_dead_servers               = var.raft_autopilot.cleanup_dead_servers
  dead_server_last_contact_threshold = var.raft_autopilot.dead_server_last_contact_threshold
  last_contact_threshold             = var.raft_autopilot.last_contact_threshold
  max_trailing_logs                  = var.raft_autopilot.max_trailing_logs
  min_quorum                         = var.raft_autopilot.min_quorum
  server_stabilization_time          = var.raft_autopilot.server_stabilization_time
  disable_upgrade_migration          = var.raft_autopilot.disable_upgrade_migration
  namespace                          = var.raft_autopilot.namespace != null ? var.raft_autopilot.namespace : var.namespace
}

resource "vault_raft_snapshot_agent_config" "this" {
  for_each = var.raft_snapshot_agent_configs

  name                          = each.value.name
  interval_seconds              = each.value.interval_seconds
  retain                        = each.value.retain
  path_prefix                   = each.value.path_prefix
  storage_type                  = each.value.storage_type
  aws_access_key_id             = each.value.aws_access_key
  aws_secret_access_key         = each.value.aws_secret_key
  aws_s3_bucket                 = each.value.aws_s3_bucket
  aws_s3_region                 = each.value.aws_s3_region
  aws_s3_endpoint               = each.value.aws_s3_endpoint
  aws_s3_server_side_encryption = each.value.aws_s3_server_side_encryption
  google_service_account_key    = each.value.google_service_account_key
  google_gcs_bucket             = each.value.google_gcs_bucket
  azure_container_name          = each.value.azure_container
  azure_account_name            = each.value.azure_account_name
  azure_account_key             = each.value.azure_account_key
  azure_endpoint                = each.value.azure_endpoint
  namespace                     = each.value.namespace != null ? each.value.namespace : var.namespace
}

###############################################################################
# Plugins
###############################################################################

resource "vault_plugin" "this" {
  for_each = var.plugins

  type      = each.value.type
  name      = each.value.name
  command   = each.value.command
  sha256    = each.value.sha256
  version   = each.value.version
  args      = each.value.args
  env       = each.value.env
  oci_image = each.value.oci_image
  runtime   = each.value.runtime
}

resource "vault_plugin_pinned_version" "this" {
  for_each = var.plugin_pinned_versions

  type    = each.value.type
  name    = each.value.name
  version = each.value.version
}
