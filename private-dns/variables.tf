variable "resource_group_name" {
  type = string
}

variable "create_private_dns_zone" {
  type    = bool
  default = true
}

variable "private_dns_zone_name" {
  type = string
}

variable "existing_private_dns_zone_id" {
  type    = string
  default = null
}

variable "create_vnet_link" {
  type    = bool
  default = true
}

variable "vnet_link_name" {
  type    = string
  default = "vnet-link"
}

variable "vnet_id" {
  type = string
}

variable "tags" {
  type = map(string)

  default = {
    ManagedBy = "terraform"
  }
}
