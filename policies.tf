###############################################################################
# Policies
###############################################################################

resource "vault_policy" "this" {
  for_each = var.policies

  name      = each.value.name
  policy    = each.value.policy
  namespace = each.value.namespace
}

###############################################################################
# Password Policies
###############################################################################

resource "vault_password_policy" "this" {
  for_each = var.password_policies

  name           = each.value.name
  policy         = each.value.policy
  entropy_source = each.value.entropy_source
  namespace      = each.value.namespace
}

###############################################################################
# Generic Endpoints
###############################################################################

resource "vault_generic_endpoint" "this" {
  for_each = var.generic_endpoints

  path                 = each.value.path
  namespace            = each.value.namespace
  data_json            = each.value.data_json
  disable_read         = each.value.disable_read
  disable_delete       = each.value.disable_delete
  ignore_absent_fields = each.value.ignore_absent_fields
  write_fields         = each.value.write_fields
}
