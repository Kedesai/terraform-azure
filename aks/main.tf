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

  vnet_name = (
    var.create_vnet
    ? azurerm_virtual_network.this[0].name
    : var.vnet_name
  )

  subnet_id = (
    var.create_subnet
    ? azurerm_subnet.aks[0].id
    : var.existing_subnet_id
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
  address_space       = var.vnet_address_space

  tags = var.tags
}

# ------------------------------------------------------------
# AKS Subnet
# ------------------------------------------------------------

resource "azurerm_subnet" "aks" {
  count = var.create_subnet ? 1 : 0

  name                 = var.subnet_name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.vnet_name
  address_prefixes     = var.subnet_address_prefixes
}

# ------------------------------------------------------------
# AKS Cluster
# ------------------------------------------------------------

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = local.location
  resource_group_name = local.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version      = var.kubernetes_version
  private_cluster_enabled = var.private_cluster_enabled

  role_based_access_control_enabled = var.rbac_enabled

  default_node_pool {
    name           = var.system_node_pool.name
    vm_size        = var.system_node_pool.vm_size
    vnet_subnet_id = local.subnet_id

    auto_scaling_enabled = var.system_node_pool.auto_scaling_enabled

    node_count = (
      var.system_node_pool.auto_scaling_enabled
      ? null
      : var.system_node_pool.node_count
    )

    min_count = (
      var.system_node_pool.auto_scaling_enabled
      ? var.system_node_pool.min_count
      : null
    )

    max_count = (
      var.system_node_pool.auto_scaling_enabled
      ? var.system_node_pool.max_count
      : null
    )

    os_disk_size_gb = var.system_node_pool.os_disk_size_gb

    type = "VirtualMachineScaleSets"
  }

  node_provisioning_profile {
    mode = "Manual"
  }

  identity {
    type = var.identity_type

    identity_ids = (
      var.identity_type == "UserAssigned"
      ? var.identity_ids
      : null
    )
  }

  network_profile {
    network_plugin      = var.network_plugin
    network_plugin_mode = var.network_plugin_mode
    network_policy      = var.network_policy

    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip

    pod_cidr = (
      var.network_plugin_mode == "overlay"
      ? var.pod_cidr
      : null
    )
  }

  automatic_upgrade_channel = var.automatic_upgrade_channel
  node_os_upgrade_channel   = var.node_os_upgrade_channel

  tags = var.tags
}

# ------------------------------------------------------------
# Additional Node Pools
# ------------------------------------------------------------

# ------------------------------------------------------------
# Additional Node Pools
# ------------------------------------------------------------

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = var.additional_node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id

  vm_size        = each.value.vm_size
  vnet_subnet_id = local.subnet_id

  auto_scaling_enabled = each.value.auto_scaling_enabled

  node_count = (
    each.value.auto_scaling_enabled
    ? null
    : each.value.node_count
  )

  min_count = (
    each.value.auto_scaling_enabled
    ? each.value.min_count
    : null
  )

  max_count = (
    each.value.auto_scaling_enabled
    ? each.value.max_count
    : null
  )

  os_disk_size_gb = each.value.os_disk_size_gb

  mode = each.value.mode

  node_labels = each.value.node_labels
  node_taints = each.value.node_taints

  tags = merge(
    var.tags,
    each.value.tags
  )
}
