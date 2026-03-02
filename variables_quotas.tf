###############################################################################
# Resource Quotas
###############################################################################

variable "quota_rate_limits" {
  description = "A map of rate limit quotas to configure."
  type = map(object({
    name           = string
    path           = optional(string)
    rate           = number
    secondary_rate = optional(number)
    interval       = optional(number)
    block_interval = optional(number)
    role           = optional(string)
    inheritable    = optional(bool)
    group_by       = optional(string)
    namespace      = optional(string)
  }))
  default = {}
}

variable "quota_lease_counts" {
  description = "A map of lease count quotas to configure."
  type = map(object({
    name        = string
    path        = optional(string)
    max_leases  = number
    role        = optional(string)
    inheritable = optional(bool)
    namespace   = optional(string)
  }))
  default = {}
}
