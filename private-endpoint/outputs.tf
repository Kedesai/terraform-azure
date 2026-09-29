output "private_endpoint_id" {
  value = azurerm_private_endpoint.this.id
}

output "private_endpoint_name" {
  value = azurerm_private_endpoint.this.name
}

output "network_interface" {
  value = azurerm_private_endpoint.this.network_interface
}
