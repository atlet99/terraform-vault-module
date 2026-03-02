###############################################################################
# Secrets Sync (Phase 5)
###############################################################################

resource "vault_secrets_sync_config" "this" {
  count = var.secrets_sync_config != null ? 1 : 0

  disabled       = var.secrets_sync_config.disabled
  queue_capacity = var.secrets_sync_config.queue_capacity
  namespace      = var.secrets_sync_config.namespace != null ? var.secrets_sync_config.namespace : var.namespace
}

resource "vault_secrets_sync_aws_destination" "this" {
  for_each = var.secrets_sync_aws_destinations

  name                      = each.value.name
  access_key_id             = each.value.access_key_id
  secret_access_key         = each.value.secret_access_key
  region                    = each.value.region
  role_arn                  = each.value.role_arn
  external_id               = each.value.external_id
  secret_name_template      = each.value.secret_name_template
  granularity               = each.value.granularity
  custom_tags               = each.value.custom_tags
  allowed_ipv4_addresses    = each.value.allowed_ipv4_addresses
  allowed_ipv6_addresses    = each.value.allowed_ipv6_addresses
  allowed_ports             = each.value.allowed_ports
  disable_strict_networking = each.value.disable_strict_networking
  namespace                 = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_secrets_sync_azure_destination" "this" {
  for_each = var.secrets_sync_azure_destinations

  name                      = each.value.name
  client_id                 = each.value.client_id
  client_secret             = each.value.client_secret
  tenant_id                 = each.value.tenant_id
  key_vault_uri             = each.value.key_vault_uri
  cloud                     = each.value.cloud
  secret_name_template      = each.value.secret_name_template
  granularity               = each.value.granularity
  custom_tags               = each.value.custom_tags
  allowed_ipv4_addresses    = each.value.allowed_ipv4_addresses
  allowed_ipv6_addresses    = each.value.allowed_ipv6_addresses
  allowed_ports             = each.value.allowed_ports
  disable_strict_networking = each.value.disable_strict_networking
  namespace                 = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_secrets_sync_gcp_destination" "this" {
  for_each = var.secrets_sync_gcp_destinations

  name                      = each.value.name
  credentials               = each.value.credentials
  project_id                = each.value.project_id
  secret_name_template      = each.value.secret_name_template
  granularity               = each.value.granularity
  custom_tags               = each.value.custom_tags
  replication_locations     = each.value.replication_locations
  locational_kms_keys       = each.value.locational_kms_keys
  global_kms_key            = each.value.global_kms_key
  allowed_ipv4_addresses    = each.value.allowed_ipv4_addresses
  allowed_ipv6_addresses    = each.value.allowed_ipv6_addresses
  allowed_ports             = each.value.allowed_ports
  disable_strict_networking = each.value.disable_strict_networking
  namespace                 = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_secrets_sync_gh_destination" "this" {
  for_each = var.secrets_sync_gh_destinations

  name                      = each.value.name
  access_token              = each.value.access_token
  repository_owner          = each.value.repository_owner
  repository_name           = each.value.repository_name
  app_name                  = each.value.app_name
  installation_id           = each.value.installation_id
  secret_name_template      = each.value.secret_name_template
  granularity               = each.value.granularity
  secrets_location          = each.value.secrets_location
  environment_name          = each.value.environment_name
  allowed_ipv4_addresses    = each.value.allowed_ipv4_addresses
  allowed_ipv6_addresses    = each.value.allowed_ipv6_addresses
  allowed_ports             = each.value.allowed_ports
  disable_strict_networking = each.value.disable_strict_networking
  namespace                 = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_secrets_sync_vercel_destination" "this" {
  for_each = var.secrets_sync_vercel_destinations

  name                      = each.value.name
  access_token              = each.value.access_token
  project_id                = each.value.project_id
  deployment_environments   = each.value.deployment_environments
  team_id                   = each.value.team_id
  secret_name_template      = each.value.secret_name_template
  granularity               = each.value.granularity
  allowed_ipv4_addresses    = each.value.allowed_ipv4_addresses
  allowed_ipv6_addresses    = each.value.allowed_ipv6_addresses
  allowed_ports             = each.value.allowed_ports
  disable_strict_networking = each.value.disable_strict_networking
  namespace                 = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_secrets_sync_association" "this" {
  for_each = var.secrets_sync_associations

  type        = each.value.type
  name        = each.value.name
  mount       = each.value.mount
  secret_name = each.value.secret_name
  namespace   = each.value.namespace != null ? each.value.namespace : var.namespace

  depends_on = [
    vault_secrets_sync_aws_destination.this,
    vault_secrets_sync_azure_destination.this,
    vault_secrets_sync_gcp_destination.this,
    vault_secrets_sync_gh_destination.this,
    vault_secrets_sync_vercel_destination.this
  ]
}
