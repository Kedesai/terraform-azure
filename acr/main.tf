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

  acr_id = (
    var.create_acr
    ? azurerm_container_registry.this[0].id
    : var.existing_acr_id
  )

  acr_name = (
    var.create_acr
    ? azurerm_container_registry.this[0].name
    : var.acr_name
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
# Azure Container Registry
# ------------------------------------------------------------

resource "azurerm_container_registry" "this" {
  count = var.create_acr ? 1 : 0

  name                = var.acr_name
  resource_group_name = local.resource_group_name
  location            = local.location

  sku           = var.sku
  admin_enabled = var.admin_enabled

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : [1]

    content {
      type = var.identity_type

      identity_ids = (
        var.identity_type == "UserAssigned"
        ? var.identity_ids
        : null
      )
    }
  }

  tags = var.tags
}

# ------------------------------------------------------------
# Optional Role Assignments
# ------------------------------------------------------------

resource "azurerm_role_assignment" "this" {
  for_each = var.create_acr ? var.role_assignments : {}

  scope                = azurerm_container_registry.this[0].id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id

  skip_service_principal_aad_check = (
    each.value.skip_service_principal_aad_check
  )
}
