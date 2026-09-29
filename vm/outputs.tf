output "vm_id" {
  description = "Linux VM resource ID"
  value       = azurerm_linux_virtual_machine.this.id
}

output "vm_name" {
  description = "Linux VM name"
  value       = azurerm_linux_virtual_machine.this.name
}

output "network_interface_id" {
  description = "VM Network Interface resource ID"
  value       = azurerm_network_interface.this.id
}

output "private_ip_address" {
  description = "VM private IP address"
  value       = azurerm_network_interface.this.private_ip_address
}

output "identity" {
  description = "VM managed identity"
  value       = azurerm_linux_virtual_machine.this.identity
}

output "data_disk_ids" {
  description = "Managed data disk resource IDs"

  value = {
    for name, disk in azurerm_managed_disk.this :
    name => disk.id
  }
}

output "resource_group_name" {
  description = "VM Resource Group"
  value       = local.resource_group_name
}
