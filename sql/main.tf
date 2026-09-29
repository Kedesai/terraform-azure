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

  sql_server_id = (
    var.create_sql_server
    ? azurerm_mssql_server.this[0].id
    : var.existing_sql_server_id
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
# SQL Logical Server
# ------------------------------------------------------------

resource "azurerm_mssql_server" "this" {
  count = var.create_sql_server ? 1 : 0

  name                = var.sql_server_name
  resource_group_name = local.resource_group_name
  location            = local.location

  version = var.sql_server_version

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  minimum_tls_version = var.minimum_tls_version

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "azuread_administrator" {
    for_each = var.azuread_administrator == null ? [] : [var.azuread_administrator]

    content {
      login_username              = azuread_administrator.value.login_username
      object_id                   = azuread_administrator.value.object_id
      tenant_id                   = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
    }
  }

  tags = var.tags
}

# ------------------------------------------------------------
# SQL Databases
# ------------------------------------------------------------

resource "azurerm_mssql_database" "this" {
  for_each = var.databases

  name      = each.key
  server_id = local.sql_server_id

  sku_name    = each.value.sku_name
  max_size_gb = each.value.max_size_gb

  collation = each.value.collation

  zone_redundant = each.value.zone_redundant

  storage_account_type = each.value.storage_account_type

  tags = merge(
    var.tags,
    each.value.tags
  )
}
