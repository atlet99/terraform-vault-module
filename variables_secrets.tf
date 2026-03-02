###############################################################################
# Transit Keys
###############################################################################

variable "transit_keys" {
  description = "Map of Transit secret backend keys to create."
  type = map(object({
    name                   = string
    backend                = string
    type                   = optional(string, "aes256-gcm96")
    deletion_allowed       = optional(bool, false)
    derived                = optional(bool, false)
    exportable             = optional(bool, false)
    allow_plaintext_backup = optional(bool, false)
    auto_rotate_period     = optional(number, null)
    min_decryption_version = optional(number, 1)
    min_encryption_version = optional(number, 0)
    context                = optional(string, null)
    key_size               = optional(number, 0)
    namespace              = optional(string, null)
  }))
  default = {}
}

###############################################################################
# Database Secret Backend
###############################################################################

variable "database_connections" {
  description = "Map of Database secret backend connections."
  type = map(object({
    name              = string
    backend           = string
    allowed_roles     = optional(list(string), null)
    plugin_name       = optional(string, null)
    verify_connection = optional(bool, true)
    namespace         = optional(string, null)

    postgresql = optional(object({
      connection_url          = string
      max_open_connections    = optional(number, null)
      max_idle_connections    = optional(number, null)
      max_connection_lifetime = optional(number, null)
      username_template       = optional(string, null)
    }), null)

    mysql = optional(object({
      connection_url          = string
      max_open_connections    = optional(number, null)
      max_idle_connections    = optional(number, null)
      max_connection_lifetime = optional(number, null)
      username_template       = optional(string, null)
    }), null)
  }))
  default = {}
}

variable "database_roles" {
  description = "Map of Database secret backend roles (dynamic credentials)."
  type = map(object({
    name                  = string
    backend               = string
    db_name               = string
    creation_statements   = list(string)
    revocation_statements = optional(list(string), null)
    default_ttl           = optional(number, null)
    max_ttl               = optional(number, null)
    namespace             = optional(string, null)
  }))
  default = {}
}

variable "database_static_roles" {
  description = "Map of Database secret backend static roles."
  type = map(object({
    name                = string
    backend             = string
    db_name             = string
    username            = string
    rotation_period     = number
    rotation_window     = optional(number, null)
    rotation_statements = optional(list(string), null)
    namespace           = optional(string, null)
  }))
  default = {}
}

###############################################################################
# PKI Secret Backend
###############################################################################

variable "pki_roles" {
  description = "Map of PKI secret backend roles."
  type = map(object({
    name               = string
    backend            = string
    ttl                = optional(string, null)
    max_ttl            = optional(string, null)
    allow_localhost    = optional(bool, true)
    allowed_domains    = optional(list(string), null)
    allow_bare_domains = optional(bool, false)
    allow_subdomains   = optional(bool, false)
    allow_any_name     = optional(bool, false)
    enforce_hostnames  = optional(bool, true)
    allow_ip_sans      = optional(bool, true)
    server_flag        = optional(bool, true)
    client_flag        = optional(bool, true)
    key_type           = optional(string, "rsa")
    key_bits           = optional(number, 2048)
    no_store           = optional(bool, false)
    namespace          = optional(string, null)
  }))
  default = {}
}

variable "pki_secret_backend_config_acmes" {
  description = "A map of PKI ACME configurations."
  type = map(object({
    backend                  = string
    enabled                  = bool
    default_directory_policy = optional(string)
    allowed_roles            = optional(list(string))
    allow_role_ext_key_usage = optional(bool)
    allowed_issuers          = optional(list(string))
    eab_policy               = optional(string)
    dns_resolver             = optional(string)
    max_ttl                  = optional(number)
    namespace                = optional(string)
  }))
  default = {}
}

variable "pki_secret_backend_acme_eabs" {
  description = "A map of PKI ACME EAB tokens."
  type = map(object({
    backend   = string
    issuer    = optional(string)
    role      = optional(string)
    namespace = optional(string)
  }))
  default = {}
}

###############################################################################
# AWS Secret Backend
###############################################################################

variable "aws_roles" {
  description = "Map of AWS secret backend roles."
  type = map(object({
    name            = string
    backend         = string
    credential_type = string # iam_user, assumed_role, federation_token
    policy_arns     = optional(list(string), null)
    policy_document = optional(string, null)
    role_arns       = optional(list(string), null)
    default_sts_ttl = optional(number, null)
    max_sts_ttl     = optional(number, null)
    iam_groups      = optional(list(string), null)
    namespace       = optional(string, null)
  }))
  default = {}
}

variable "aws_static_roles" {
  description = "Map of AWS secret backend static roles."
  type = map(object({
    name                     = string
    backend                  = optional(string, "aws")
    username                 = string
    rotation_period          = string
    assume_role_arn          = optional(string, null)
    assume_role_session_name = optional(string, null)
    external_id              = optional(string, null)
    namespace                = optional(string, null)
  }))
  default = {}
}

###############################################################################
# SSH Secret Backend
###############################################################################

variable "ssh_roles" {
  description = "Map of SSH secret backend roles."
  type = map(object({
    name                     = string
    backend                  = string
    key_type                 = string
    allow_bare_domains       = optional(bool, false)
    allow_host_certificates  = optional(bool, false)
    allow_subdomains         = optional(bool, false)
    allow_user_certificates  = optional(bool, false)
    allow_user_key_ids       = optional(bool, false)
    allowed_critical_options = optional(string, null)
    allowed_domains_template = optional(bool, null)
    allowed_domains          = optional(string, null)
    cidr_list                = optional(string, null)
    allowed_extensions       = optional(string, null)
    default_extensions       = optional(map(string), null)
    default_critical_options = optional(map(string), null)
    allowed_users_template   = optional(bool, false)
    allowed_users            = optional(string, null)
    default_user             = optional(string, null)
    default_user_template    = optional(bool, null)
    key_id_format            = optional(string, null)
    algorithm_signer         = optional(string, null)
    max_ttl                  = optional(string, null)
    ttl                      = optional(string, null)
    not_before_duration      = optional(string, null)
    allow_empty_principals   = optional(bool, false)
    allowed_user_key_config = optional(list(object({
      type    = string
      lengths = list(number)
    })), null)
    namespace = optional(string, null)
  }))
  default = {}
}

###############################################################################
# Azure Secret Backend
###############################################################################

variable "azure_secret_backends" {
  description = "A map of Azure secret backends to configure."
  type = map(object({
    path            = optional(string, "azure")
    description     = optional(string, "Azure secret backend")
    subscription_id = string
    tenant_id       = string
    client_id       = optional(string)
    client_secret   = optional(string)
    environment     = optional(string, "AzurePublicCloud")
    namespace       = optional(string)
  }))
  default = {}
}

variable "azure_secret_backend_roles" {
  description = "A map of roles for Azure secret backends."
  type = map(object({
    role                  = string
    backend               = optional(string, "azure")
    namespace             = optional(string)
    azure_roles           = optional(list(any))
    azure_groups          = optional(list(any))
    application_object_id = optional(string)
    ttl                   = optional(string)
    max_ttl               = optional(string)
    permanently_delete    = optional(bool)
  }))
  default = {}
}

variable "azure_static_roles" {
  description = "Map of Azure secret backend static roles."
  type = map(object({
    role                  = string
    backend               = string
    application_object_id = string
    ttl                   = optional(string, null)
    metadata              = optional(map(string), null)
    secret_id             = optional(string, null)
    client_secret         = optional(string, null)
    expiration            = optional(string, null)
    skip_import_rotation  = optional(bool, false)
    namespace             = optional(string, null)
  }))
  default = {}
}

###############################################################################
# GCP Secret Backend
###############################################################################

variable "gcp_secret_backends" {
  description = "A map of GCP secret backends to configure."
  type = map(object({
    path                      = optional(string, "gcp")
    description               = optional(string, "GCP secret backend")
    credentials               = optional(string)
    default_lease_ttl_seconds = optional(number)
    max_lease_ttl_seconds     = optional(number)
    namespace                 = optional(string)
  }))
  default = {}
}

variable "gcp_secret_backend_rolesets" {
  description = "A map of rolesets for GCP secret backends."
  type = map(object({
    roleset      = string
    backend      = optional(string, "gcp")
    project      = string
    secret_type  = string
    bindings     = list(any)
    token_scopes = optional(list(string))
    namespace    = optional(string)
  }))
  default = {}
}

variable "gcp_secret_backend_static_accounts" {
  description = "A map of static accounts for GCP secret backends."
  type = map(object({
    static_account        = string
    backend               = optional(string, "gcp")
    service_account_email = string
    secret_type           = string
    token_scopes          = optional(list(string))
    bindings              = optional(list(any))
    namespace             = optional(string)
  }))
  default = {}
}

###############################################################################
# LDAP Secret Backend
###############################################################################

variable "ldap_secret_backends" {
  description = "A map of LDAP secret backends to configure."
  type = map(object({
    path               = optional(string, "ldap")
    description        = optional(string, "LDAP secret backend")
    binddn             = string
    bindpass           = optional(string)
    url                = optional(string)
    userdn             = optional(string)
    userattr           = optional(string)
    upndomain          = optional(string)
    insecure_tls       = optional(bool)
    starttls           = optional(bool)
    certificate        = optional(string)
    client_tls_cert    = optional(string)
    client_tls_key     = optional(string)
    password_policy    = optional(string)
    schema             = optional(string)
    connection_timeout = optional(number)
    request_timeout    = optional(number)
    credential_type    = optional(string)
    namespace          = optional(string)
  }))
  default = {}
}

variable "ldap_secret_backend_library_sets" {
  description = "A map of library sets for LDAP secret backends."
  type = map(object({
    name                         = string
    mount                        = optional(string, "ldap")
    service_account_names        = list(string)
    ttl                          = optional(number)
    max_ttl                      = optional(number)
    disable_check_in_enforcement = optional(bool)
    namespace                    = optional(string)
  }))
  default = {}
}

variable "ldap_secret_backend_static_roles" {
  description = "A map of static roles for LDAP secret backends."
  type = map(object({
    role_name            = string
    mount                = optional(string, "ldap")
    username             = string
    dn                   = optional(string)
    rotation_period      = number
    skip_import_rotation = optional(bool)
    namespace            = optional(string)
  }))
  default = {}
}

###############################################################################
# Consul Secret Backend
###############################################################################

variable "consul_secret_backends" {
  description = "A map of Consul secret backends to configure."
  type = map(object({
    path                      = optional(string, "consul")
    description               = optional(string, "Consul secret backend")
    address                   = string
    scheme                    = optional(string)
    token                     = string
    namespace                 = optional(string)
    default_lease_ttl_seconds = optional(number)
    max_lease_ttl_seconds     = optional(number)
  }))
  default = {}
}

variable "consul_secret_roles" {
  description = "A map of roles for Consul secret backends."
  type = map(object({
    name               = string
    backend            = string
    policies           = optional(list(string))
    consul_namespace   = optional(string)
    consul_roles       = optional(list(string))
    partition          = optional(string)
    node_identities    = optional(list(string))
    service_identities = optional(list(string))
    ttl                = optional(number)
    max_ttl            = optional(number)
    namespace          = optional(string)
  }))
  default = {}
}

###############################################################################
# Nomad Secret Backend
###############################################################################

variable "nomad_secret_backends" {
  description = "A map of Nomad secret backends to configure."
  type = map(object({
    path                      = optional(string, "nomad")
    description               = optional(string, "Nomad secret backend")
    address                   = string
    token                     = string
    max_token_name_length     = optional(number)
    namespace                 = optional(string)
    default_lease_ttl_seconds = optional(number)
    max_lease_ttl_seconds     = optional(number)
  }))
  default = {}
}

variable "nomad_secret_roles" {
  description = "A map of roles for Nomad secret backends."
  type = map(object({
    role      = string
    backend   = string
    policies  = optional(list(string))
    global    = optional(bool)
    type      = optional(string)
    namespace = optional(string)
  }))
  default = {}
}

###############################################################################
# MongoDB Atlas Secret Backend
###############################################################################

variable "mongodbatlas_secret_backends" {
  description = "A map of MongoDB Atlas secret backends to configure."
  type = map(object({
    path        = optional(string, "mongodbatlas")
    description = optional(string, "MongoDB Atlas secret backend")
    private_key = string
    public_key  = string
    namespace   = optional(string)
  }))
  default = {}
}

variable "mongodbatlas_secret_roles" {
  description = "A map of roles for MongoDB Atlas secret backends."
  type = map(object({
    name            = string
    mount           = string
    organization_id = optional(string)
    project_id      = optional(string)
    roles           = list(string)
    project_roles   = optional(list(string))
    ip_addresses    = optional(string)
    cidr_blocks     = optional(string)
    ttl             = optional(string)
    max_ttl         = optional(string)
    namespace       = optional(string)
  }))
  default = {}
}

###############################################################################
# RabbitMQ Secret Backend
###############################################################################

variable "rabbitmq_secret_backends" {
  description = "A map of RabbitMQ secret backends to configure."
  type = map(object({
    path              = optional(string, "rabbitmq")
    description       = optional(string, "RabbitMQ secret backend")
    connection_uri    = string
    username          = string
    password          = string
    verify_connection = optional(bool)
    namespace         = optional(string)
  }))
  default = {}
}

variable "rabbitmq_secret_roles" {
  description = "A map of roles for RabbitMQ secret backends."
  type = map(object({
    name    = string
    backend = string
    tags    = optional(string)
    vhost = optional(map(object({
      configure = string
      read      = string
      write     = string
    })))
    vhost_topics = optional(map(map(object({
      read  = string
      write = string
    }))))
    namespace = optional(string)
  }))
  default = {}
}

###############################################################################
# Terraform Cloud Secret Backend
###############################################################################

variable "terraform_cloud_secret_backends" {
  description = "A map of Terraform Cloud secret backends to configure."
  type = map(object({
    path        = optional(string, "terraform")
    description = optional(string, "Terraform Cloud secret backend")
    token       = string
    address     = optional(string)
    base_path   = optional(string)
    namespace   = optional(string)
  }))
  default = {}
}

variable "terraform_cloud_secret_roles" {
  description = "A map of roles for Terraform Cloud secret backends."
  type = map(object({
    name         = string
    backend      = string
    organization = optional(string)
    team_id      = optional(string)
    user_id      = optional(string)
    ttl          = optional(number)
    max_ttl      = optional(number)
    namespace    = optional(string)
  }))
  default = {}
}

###############################################################################
# KMIP Secret Backend (Enterprise)
###############################################################################

variable "kmip_secret_backends" {
  description = "A map of KMIP secret backends to configure."
  type = map(object({
    path                        = string
    description                 = optional(string, "KMIP secret backend")
    listen_addrs                = optional(list(string))
    tls_ca_key_type             = optional(string)
    tls_ca_key_bits             = optional(number)
    tls_min_version             = optional(string)
    server_hostnames            = optional(list(string))
    server_ips                  = optional(list(string))
    default_tls_client_key_type = optional(string)
    default_tls_client_key_bits = optional(number)
    default_tls_client_ttl      = optional(number)
    namespace                   = optional(string)
  }))
  default = {}
}

variable "kmip_secret_roles" {
  description = "A map of roles for KMIP secret backends."
  type = map(object({
    role                        = string
    path                        = string
    scope                       = string
    tls_client_key_type         = optional(string)
    tls_client_key_bits         = optional(number)
    tls_client_ttl              = optional(number)
    operation_all               = optional(bool)
    operation_activate          = optional(bool)
    operation_create            = optional(bool)
    operation_get               = optional(bool)
    operation_get_attributes    = optional(bool)
    operation_destroy           = optional(bool)
    operation_discover_versions = optional(bool)
    operation_register          = optional(bool)
    operation_revoke            = optional(bool)
    namespace                   = optional(string)
  }))
  default = {}
}

variable "kmip_secret_scopes" {
  description = "A map of scopes for KMIP secret backends."
  type = map(object({
    scope     = string
    path      = string
    force     = optional(bool)
    namespace = optional(string)
  }))
  default = {}
}

###############################################################################
# Transform Secret Backend (Enterprise)
###############################################################################

variable "transform_alphabets" {
  description = "A map of alphabets for Transform secret backends."
  type = map(object({
    name      = string
    path      = string
    alphabet  = string
    namespace = optional(string)
  }))
  default = {}
}

variable "transform_templates" {
  description = "A map of templates for Transform secret backends."
  type = map(object({
    name           = string
    path           = string
    type           = optional(string, "regex")
    pattern        = optional(string)
    alphabet       = optional(string)
    encode_format  = optional(string)
    decode_formats = optional(map(string))
    namespace      = optional(string)
  }))
  default = {}
}

variable "transform_transformations" {
  description = "A map of transformations for Transform secret backends."
  type = map(object({
    name              = string
    path              = string
    type              = optional(string, "fpe")
    template          = optional(string)
    tweak_source      = optional(string, "supplied")
    masking_character = optional(string)
    allowed_roles     = optional(list(string))
    namespace         = optional(string)
  }))
  default = {}
}

variable "transform_roles" {
  description = "A map of roles for Transform secret backends."
  type = map(object({
    name            = string
    path            = string
    transformations = optional(list(string))
    namespace       = optional(string)
  }))
  default = {}
}

###############################################################################
# Managed Keys (Vault Enterprise)
###############################################################################

variable "managed_keys" {
  description = "A single configuration object for all Managed Keys. Note: Vault supports only one Managed Keys resource per namespace/state."
  type = object({
    namespace = optional(string)
    aws = optional(list(object({
      name               = string
      access_key         = string
      secret_key         = string
      key_bits           = string
      key_type           = string
      kms_key            = string
      curve              = optional(string)
      endpoint           = optional(string)
      region             = optional(string)
      allow_generate_key = optional(bool)
      allow_replace_key  = optional(bool)
      allow_store_key    = optional(bool)
      any_mount          = optional(bool)
    })))
    azure = optional(list(object({
      name               = string
      tenant_id          = string
      client_id          = string
      client_secret      = string
      vault_name         = string
      key_name           = string
      key_type           = string
      environment        = optional(string)
      resource           = optional(string)
      key_bits           = optional(number)
      allow_generate_key = optional(bool)
      allow_replace_key  = optional(bool)
      allow_store_key    = optional(bool)
      any_mount          = optional(bool)
    })))
    pkcs = optional(list(object({
      name               = string
      library            = string
      key_label          = string
      key_id             = string
      mechanism          = string
      pin                = string
      slot               = optional(string)
      token_label        = optional(string)
      curve              = optional(string)
      key_bits           = optional(number)
      force_rw_session   = optional(bool)
      allow_generate_key = optional(bool)
      allow_replace_key  = optional(bool)
      allow_store_key    = optional(bool)
      any_mount          = optional(bool)
    })))
  })
  default = null
}

variable "kv_secrets" {
  description = "Map of KV-V1 secrets to create."
  type = map(object({
    path      = string
    data_json = string
    namespace = optional(string, null)
  }))
  default = {}
}
