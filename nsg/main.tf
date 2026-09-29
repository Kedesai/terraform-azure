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

  nsg_id = (
    var.create_nsg
    ? azurerm_network_security_group.this[0].id
    : var.existing_nsg_id
  )

  nsg_name = (
    var.create_nsg
    ? azurerm_network_security_group.this[0].name
    : var.nsg_name
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
# Network Security Group
# ------------------------------------------------------------

resource "azurerm_network_security_group" "this" {
  count = var.create_nsg ? 1 : 0

  name                = var.nsg_name
  location            = local.location
  resource_group_name = local.resource_group_name

  tags = var.tags
}

# ------------------------------------------------------------
# Security Rules
# Only managed when this module creates the NSG
# ------------------------------------------------------------

resource "azurerm_network_security_rule" "this" {
  for_each = var.create_nsg ? var.security_rules : {}

  name = each.key

  priority  = each.value.priority
  direction = each.value.direction
  access    = each.value.access
  protocol  = each.value.protocol

  source_port_range      = each.value.source_port_range
  destination_port_range = each.value.destination_port_range

  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix

  resource_group_name         = local.resource_group_name
  network_security_group_name = local.nsg_name

  description = each.value.description
}

# ------------------------------------------------------------
# Optional Subnet Association
# ------------------------------------------------------------

resource "azurerm_subnet_network_security_group_association" "this" {
  count = var.associate_subnet ? 1 : 0

  subnet_id                 = var.subnet_id
  network_security_group_id = local.nsg_id
}
