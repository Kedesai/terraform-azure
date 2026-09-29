locals {
  resource_group_name = (
    var.create_resource_group
    ? azurerm_resource_group.this[0].name
    : var.resource_group_name
  )

  location = (
    var.create_resource_group
    ? azurerm_resource_group.this[0].location
    : var.location
  )

  key_vault_id = (
    var.create_key_vault
    ? azurerm_key_vault.this[0].id
    : var.existing_key_vault_id
  )

  key_vault_name = (
    var.create_key_vault
    ? azurerm_key_vault.this[0].name
    : var.key_vault_name
  )
}

# ------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------

resource "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 1 : 0

  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# ------------------------------------------------------------
# Key Vault
# ------------------------------------------------------------

resource "azurerm_key_vault" "this" {
  count = var.create_key_vault ? 1 : 0

  name                = var.key_vault_name
  location            = local.location
  resource_group_name = local.resource_group_name

  tenant_id = var.tenant_id
  sku_name  = var.sku_name

  rbac_authorization_enabled = var.rbac_authorization_enabled

  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  public_network_access_enabled = var.public_network_access_enabled

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  tags = var.tags
}

# ------------------------------------------------------------
# Optional RBAC Role Assignments
# ------------------------------------------------------------

resource "azurerm_role_assignment" "this" {
  for_each = var.create_key_vault ? var.role_assignments : {}

  scope                = azurerm_key_vault.this[0].id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id

  skip_service_principal_aad_check = (
    each.value.skip_service_principal_aad_check
  )
}
