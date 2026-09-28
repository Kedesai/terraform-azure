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

  vnet_id = (
    var.create_vnet
    ? azurerm_virtual_network.this[0].id
    : var.existing_vnet_id
  )

  vnet_name = (
    var.create_vnet
    ? azurerm_virtual_network.this[0].name
    : var.vnet_name
  )

  subnet_ids = (
    var.create_vnet
    ? {
      for name, subnet in azurerm_subnet.this :
      name => subnet.id
    }
    : var.existing_subnet_ids
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
# Virtual Network
# ------------------------------------------------------------

resource "azurerm_virtual_network" "this" {
  count = var.create_vnet ? 1 : 0

  name                = var.vnet_name
  location            = local.location
  resource_group_name = local.resource_group_name

  address_space = var.address_space
  dns_servers   = var.dns_servers

  tags = var.tags
}

# ------------------------------------------------------------
# Subnets
# ------------------------------------------------------------

resource "azurerm_subnet" "this" {
  for_each = var.create_vnet ? var.subnets : {}

  name = each.key

  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name

  address_prefixes = each.value.address_prefixes

  service_endpoints = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegation == null ? [] : [each.value.delegation]

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.actions
      }
    }
  }
}
