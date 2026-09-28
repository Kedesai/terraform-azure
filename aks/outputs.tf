output "resource_group_name" {
  description = "Resource group containing AKS"
  value       = local.resource_group_name
}

output "resource_group_location" {
  description = "Azure region containing AKS"
  value       = local.location
}

output "vnet_name" {
  description = "Virtual network used by AKS"
  value       = local.vnet_name
}

output "subnet_id" {
  description = "Subnet used by AKS"
  value       = local.subnet_id
}

output "cluster_id" {
  description = "AKS cluster resource ID"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_fqdn" {
  description = "AKS API FQDN"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "cluster_private_fqdn" {
  description = "AKS private API FQDN"
  value       = azurerm_kubernetes_cluster.this.private_fqdn
}

output "cluster_identity" {
  description = "AKS managed identity"
  value       = azurerm_kubernetes_cluster.this.identity
}

output "node_resource_group" {
  description = "AKS managed node resource group"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

output "kube_config" {
  description = "Raw Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}
