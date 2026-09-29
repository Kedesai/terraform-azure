output "resource_group_name" {
  description = "Resource Group containing the NSG"
  value       = local.resource_group_name
}

output "location" {
  description = "Azure region"
  value       = local.location
}

output "nsg_id" {
  description = "Network Security Group resource ID"
  value       = local.nsg_id
}

output "nsg_name" {
  description = "Network Security Group name"
  value       = local.nsg_name
}
