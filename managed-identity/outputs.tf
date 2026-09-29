output "resource_group_name" {
  description = "Resource Group containing the identity"
  value       = local.resource_group_name
}

output "identity_id" {
  description = "Managed Identity resource ID"
  value       = local.identity_id
}

output "identity_name" {
  description = "Managed Identity name"
  value       = local.identity_name
}

output "client_id" {
  description = "Managed Identity client ID"

  value = (
    var.create_identity
    ? azurerm_user_assigned_identity.this[0].client_id
    : null
  )
}

output "principal_id" {
  description = "Managed Identity principal ID"

  value = (
    var.create_identity
    ? azurerm_user_assigned_identity.this[0].principal_id
    : null
  )
}
