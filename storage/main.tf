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

  storage_account_id = (
    var.create_storage_account
    ? azurerm_storage_account.this[0].id
    : var.existing_storage_account_id
  )

  storage_account_name = (
    var.create_storage_account
    ? azurerm_storage_account.this[0].name
    : var.storage_account_name
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
# Storage Account
# ------------------------------------------------------------

resource "azurerm_storage_account" "this" {
  count = var.create_storage_account ? 1 : 0

  name                = var.storage_account_name
  resource_group_name = local.resource_group_name
  location            = local.location

  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier

  https_traffic_only_enabled = var.https_traffic_only_enabled
  min_tls_version            = var.min_tls_version

  public_network_access_enabled   = var.public_network_access_enabled
  shared_access_key_enabled       = var.shared_access_key_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public

  tags = var.tags
}

# ------------------------------------------------------------
# Blob Containers
# ------------------------------------------------------------

resource "azurerm_storage_container" "this" {
  for_each = var.create_storage_account ? var.containers : {}

  name                  = each.key
  storage_account_id    = azurerm_storage_account.this[0].id
  container_access_type = each.value.container_access_type
}
