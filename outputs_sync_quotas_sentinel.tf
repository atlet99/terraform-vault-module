###############################################################################
# Secrets Sync
###############################################################################

output "secrets_sync_config" {
  description = "Secrets sync configuration."
  value       = vault_secrets_sync_config.this
}

output "secrets_sync_aws_destinations" {
  description = "Map of Secrets Sync AWS destination keys to their names."
  value       = { for k, v in vault_secrets_sync_aws_destination.this : k => v.name }
}

output "secrets_sync_azure_destinations" {
  description = "Map of Secrets Sync Azure destination keys to their names."
  value       = { for k, v in vault_secrets_sync_azure_destination.this : k => v.name }
}

output "secrets_sync_gcp_destinations" {
  description = "Map of Secrets Sync GCP destination keys to their names."
  value       = { for k, v in vault_secrets_sync_gcp_destination.this : k => v.name }
}

output "secrets_sync_gh_destinations" {
  description = "Map of Secrets Sync GitHub destination keys to their names."
  value       = { for k, v in vault_secrets_sync_gh_destination.this : k => v.name }
}

output "secrets_sync_associations" {
  description = "Map of Secrets Sync association keys to their mount paths and secret names."
  value = {
    for k, v in vault_secrets_sync_association.this : k => {
      mount       = v.mount
      secret_name = v.secret_name
    }
  }
}

###############################################################################
# Quotas
###############################################################################

output "quota_rate_limits" {
  description = "Map of rate limit quota keys to their names."
  value       = { for k, v in vault_quota_rate_limit.this : k => v.name }
}

output "quota_lease_counts" {
  description = "Map of lease count quota keys to their names."
  value       = { for k, v in vault_quota_lease_count.this : k => v.name }
}

###############################################################################
# Sentinel Policies (Enterprise)
###############################################################################

output "egp_policies" {
  description = "Map of Sentinel EGP policy keys to their names and enforcement levels. Enterprise only."
  value = {
    for k, v in vault_egp_policy.this : k => {
      name              = v.name
      enforcement_level = v.enforcement_level
    }
  }
}

output "rgp_policies" {
  description = "Map of Sentinel RGP policy keys to their names and enforcement levels. Enterprise only."
  value = {
    for k, v in vault_rgp_policy.this : k => {
      name              = v.name
      enforcement_level = v.enforcement_level
    }
  }
}
