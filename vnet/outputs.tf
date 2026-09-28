output "resource_group_name" {
  description = "Resource Group containing the VNet"
  value       = local.resource_group_name
}

output "location" {
  description = "Azure region"
  value       = local.location
}

output "vnet_id" {
  description = "Virtual Network resource ID"
  value       = local.vnet_id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = local.vnet_name
}

output "subnet_ids" {
  description = "Map of subnet names to subnet resource IDs"
  value       = local.subnet_ids
}
