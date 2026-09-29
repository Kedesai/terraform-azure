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

  identity_id = (
    var.create_identity
    ? azurerm_user_assigned_identity.this[0].id
    : var.existing_identity_id
  )

  identity_name = (
    var.create_identity
    ? azurerm_user_assigned_identity.this[0].name
    : var.identity_name
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
# User Assigned Managed Identity
# ------------------------------------------------------------

resource "azurerm_user_assigned_identity" "this" {
  count = var.create_identity ? 1 : 0

  name                = var.identity_name
  location            = local.location
  resource_group_name = local.resource_group_name

  tags = var.tags
}

# ------------------------------------------------------------
# Optional Role Assignments
# ------------------------------------------------------------

resource "azurerm_role_assignment" "this" {
  for_each = var.create_identity ? var.role_assignments : {}

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name

  principal_id = azurerm_user_assigned_identity.this[0].principal_id
}
