output "resource_group_name" {
  description = "Resource Group containing the Storage Account"
  value       = local.resource_group_name
}

output "location" {
  description = "Azure region"
  value       = local.location
}

output "storage_account_id" {
  description = "Storage Account resource ID"
  value       = local.storage_account_id
}

output "storage_account_name" {
  description = "Storage Account name"
  value       = local.storage_account_name
}

output "primary_blob_endpoint" {
  description = "Primary Blob endpoint"

  value = (
    var.create_storage_account
    ? azurerm_storage_account.this[0].primary_blob_endpoint
    : null
  )
}

output "container_ids" {
  description = "Created Storage Container IDs"

  value = {
    for name, container in azurerm_storage_container.this :
    name => container.id
  }
}
