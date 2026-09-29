resource "azurerm_private_dns_zone" "this" {
  count = var.create_private_dns_zone ? 1 : 0

  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name

  tags = var.tags
}

locals {
  private_dns_zone_id = (
    var.create_private_dns_zone
    ? azurerm_private_dns_zone.this[0].id
    : var.existing_private_dns_zone_id
  )
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  count = var.create_vnet_link ? 1 : 0

  name = var.vnet_link_name

  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_name

  virtual_network_id = var.vnet_id

  registration_enabled = false

  tags = var.tags
}
