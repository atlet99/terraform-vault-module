###############################################################################
# Audit Devices
###############################################################################

resource "vault_audit" "this" {
  for_each = var.audit_devices

  type        = each.value.type
  path        = each.value.path
  description = each.value.description
  local       = each.value.local
  namespace   = each.value.namespace
  options     = each.value.options
}

###############################################################################
# Audit Request Headers (Phase 4)
###############################################################################

resource "vault_audit_request_header" "this" {
  for_each = var.audit_request_headers

  name      = each.value.name
  hmac      = each.value.hmac
  namespace = each.value.namespace != null ? each.value.namespace : var.namespace
}
