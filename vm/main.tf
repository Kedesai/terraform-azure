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
# Network Interface
# ------------------------------------------------------------

resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  location            = local.location
  resource_group_name = local.resource_group_name

  accelerated_networking_enabled = var.accelerated_networking_enabled

  ip_configuration {
    name = "internal"

    subnet_id = var.subnet_id

    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address = (
      var.private_ip_address_allocation == "Static"
      ? var.private_ip_address
      : null
    )
  }

  tags = var.tags
}

# ------------------------------------------------------------
# Optional existing NSG association to NIC
# ------------------------------------------------------------

resource "azurerm_network_interface_security_group_association" "this" {
  count = var.network_security_group_id != null ? 1 : 0

  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.network_security_group_id
}

# ------------------------------------------------------------
# Linux VM
# ------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "this" {
  name                = var.vm_name
  location            = local.location
  resource_group_name = local.resource_group_name

  size = var.vm_size
  zone = var.zone

  admin_username = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name = "${var.vm_name}-osdisk"

    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image.publisher
    offer     = var.source_image.offer
    sku       = var.source_image.sku
    version   = var.source_image.version
  }

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

  boot_diagnostics {}

  tags = var.tags
}

# ------------------------------------------------------------
# Managed Data Disks
# ------------------------------------------------------------

resource "azurerm_managed_disk" "this" {
  for_each = var.data_disks

  name                = "${var.vm_name}-${each.key}"
  location            = local.location
  resource_group_name = local.resource_group_name

  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size_gb

  tags = var.tags
}

# ------------------------------------------------------------
# Attach Data Disks
# ------------------------------------------------------------

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each = var.data_disks

  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.this.id

  lun     = each.value.lun
  caching = each.value.caching
}
