output "resource_group_name" {
  description = "Resource Group containing Key Vault"
  value       = local.resource_group_name
}

output "location" {
  description = "Azure region"
  value       = local.location
}

output "key_vault_id" {
  description = "Key Vault resource ID"
  value       = local.key_vault_id
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = local.key_vault_name
}

output "vault_uri" {
  description = "Key Vault URI"

  value = (
    var.create_key_vault
    ? azurerm_key_vault.this[0].vault_uri
    : null
  )
}
