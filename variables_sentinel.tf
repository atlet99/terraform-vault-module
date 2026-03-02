###############################################################################
# Sentinel Policies (Vault Enterprise)
###############################################################################

variable "egp_policies" {
  description = "A map of Sentinel Endpoint Governing Policy (EGP) configurations. Enforced on specific Vault API paths. Enterprise only."
  type = map(object({
    name              = string
    paths             = list(string)
    enforcement_level = string
    policy            = string
    namespace         = optional(string)
  }))
  default = {}
}

variable "rgp_policies" {
  description = "A map of Sentinel Role Governing Policy (RGP) configurations. Enforced per token/role. Enterprise only."
  type = map(object({
    name              = string
    enforcement_level = string
    policy            = string
    namespace         = optional(string)
  }))
  default = {}
}
