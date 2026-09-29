output "resource_group_name" {
  description = "Resource Group containing the ACR"
  value       = local.resource_group_name
}

output "location" {
  description = "Azure region"
  value       = local.location
}

output "acr_id" {
  description = "Azure Container Registry resource ID"
  value       = local.acr_id
}

output "acr_name" {
  description = "Azure Container Registry name"
  value       = local.acr_name
}

output "login_server" {
  description = "Azure Container Registry login server"

  value = (
    var.create_acr
    ? azurerm_container_registry.this[0].login_server
    : null
  )
}
