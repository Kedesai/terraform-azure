# ------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------

variable "create_resource_group" {
  description = "Whether Terraform should create the Resource Group"
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

# ------------------------------------------------------------
# VNet
# ------------------------------------------------------------

variable "create_vnet" {
  description = "Whether Terraform should create the VNet and configured subnets"
  type        = bool
  default     = true
}

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}

variable "existing_vnet_id" {
  description = "Existing VNet resource ID when create_vnet is false"
  type        = string
  default     = null
}

variable "address_space" {
  description = "VNet address spaces"
  type        = list(string)
  default     = []
}

variable "dns_servers" {
  description = "Custom DNS servers for the VNet"
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------
# Subnets
# ------------------------------------------------------------

variable "subnets" {
  description = "Subnets to create within the VNet"

  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])

    delegation = optional(object({
      name         = string
      service_name = string
      actions      = optional(list(string), [])
    }))
  }))

  default = {}
}

variable "existing_subnet_ids" {
  description = "Existing subnet resource IDs when create_vnet is false"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------
# Tags
# ------------------------------------------------------------

variable "tags" {
  description = "Tags applied to resources"
  type        = map(string)
  default     = {}
}
