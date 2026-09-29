variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "private_endpoint_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_connection_resource_id" {
  description = "Resource ID of the Azure service receiving the Private Endpoint"
  type        = string
}

variable "subresource_names" {
  description = "Private Link subresource names"
  type        = list(string)
}

variable "is_manual_connection" {
  type    = bool
  default = false
}

variable "private_dns_zone_ids" {
  type    = list(string)
  default = []
}

variable "private_dns_zone_group_name" {
  type    = string
  default = "default"
}

variable "tags" {
  type = map(string)

  default = {
    ManagedBy = "terraform"
  }
}
