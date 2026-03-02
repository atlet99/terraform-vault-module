###############################################################################
# Resource Quotas (Phase 5)
###############################################################################

resource "vault_quota_rate_limit" "this" {
  for_each = var.quota_rate_limits

  name           = each.value.name
  path           = each.value.path
  rate           = each.value.rate
  secondary_rate = each.value.secondary_rate
  interval       = each.value.interval
  block_interval = each.value.block_interval
  role           = each.value.role
  inheritable    = each.value.inheritable
  group_by       = each.value.group_by
  namespace      = each.value.namespace != null ? each.value.namespace : var.namespace
}

resource "vault_quota_lease_count" "this" {
  for_each = var.quota_lease_counts

  name        = each.value.name
  path        = each.value.path
  max_leases  = each.value.max_leases
  role        = each.value.role
  inheritable = each.value.inheritable
  namespace   = each.value.namespace != null ? each.value.namespace : var.namespace
}
