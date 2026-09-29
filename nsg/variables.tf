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

variable "create_nsg" {
  description = "Whether Terraform should create the Network Security Group"
  type        = bool
  default     = true
}

variable "nsg_name" {
  description = "Network Security Group name"
  type        = string
}

variable "existing_nsg_id" {
  description = "Existing NSG resource ID when create_nsg is false"
  type        = string
  default     = null
}

variable "associate_subnet" {
  description = "Whether to associate the NSG with a subnet"
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "Subnet resource ID for optional NSG association"
  type        = string
  default     = null
}

variable "security_rules" {
  description = "Security rules to create when create_nsg is true"

  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    description                = optional(string)
  }))

  default = {}
}

variable "tags" {
  description = "Tags applied to resources"
  type        = map(string)
  default     = {}
}
