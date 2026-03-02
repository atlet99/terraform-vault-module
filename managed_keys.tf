###############################################################################
# Managed Keys (Vault Enterprise)
###############################################################################

resource "vault_managed_keys" "this" {
  count = var.managed_keys != null ? 1 : 0

  namespace = var.managed_keys.namespace != null ? var.managed_keys.namespace : var.namespace

  dynamic "aws" {
    for_each = var.managed_keys.aws != null ? var.managed_keys.aws : []
    content {
      name               = aws.value.name
      access_key         = aws.value.access_key
      secret_key         = aws.value.secret_key
      key_bits           = aws.value.key_bits
      key_type           = aws.value.key_type
      kms_key            = aws.value.kms_key
      curve              = aws.value.curve
      endpoint           = aws.value.endpoint
      region             = aws.value.region
      allow_generate_key = aws.value.allow_generate_key
      allow_replace_key  = aws.value.allow_replace_key
      allow_store_key    = aws.value.allow_store_key
      any_mount          = aws.value.any_mount
    }
  }

  dynamic "azure" {
    for_each = var.managed_keys.azure != null ? var.managed_keys.azure : []
    content {
      name               = azure.value.name
      tenant_id          = azure.value.tenant_id
      client_id          = azure.value.client_id
      client_secret      = azure.value.client_secret
      vault_name         = azure.value.vault_name
      key_name           = azure.value.key_name
      key_type           = azure.value.key_type
      environment        = azure.value.environment
      resource           = azure.value.resource
      key_bits           = azure.value.key_bits
      allow_generate_key = azure.value.allow_generate_key
      allow_replace_key  = azure.value.allow_replace_key
      allow_store_key    = azure.value.allow_store_key
      any_mount          = azure.value.any_mount
    }
  }

  dynamic "pkcs" {
    for_each = var.managed_keys.pkcs != null ? var.managed_keys.pkcs : []
    content {
      name               = pkcs.value.name
      library            = pkcs.value.library
      key_label          = pkcs.value.key_label
      key_id             = pkcs.value.key_id
      mechanism          = pkcs.value.mechanism
      pin                = pkcs.value.pin
      slot               = pkcs.value.slot
      token_label        = pkcs.value.token_label
      curve              = pkcs.value.curve
      key_bits           = pkcs.value.key_bits
      force_rw_session   = pkcs.value.force_rw_session
      allow_generate_key = pkcs.value.allow_generate_key
      allow_replace_key  = pkcs.value.allow_replace_key
      allow_store_key    = pkcs.value.allow_store_key
      any_mount          = pkcs.value.any_mount
    }
  }
}
