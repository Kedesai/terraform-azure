# ------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------

variable "create_resource_group" {
  description = "Whether Terraform should create the resource group"
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "Resource group containing the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

# ------------------------------------------------------------
# Virtual Network
# ------------------------------------------------------------

variable "create_vnet" {
  description = "Whether Terraform should create the virtual network"
  type        = bool
  default     = false
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space used when creating the VNet"
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------
# Subnet
# ------------------------------------------------------------

variable "create_subnet" {
  description = "Whether Terraform should create the AKS subnet"
  type        = bool
  default     = false
}

variable "subnet_name" {
  description = "AKS subnet name"
  type        = string
  default     = "snet-aks"
}

variable "subnet_address_prefixes" {
  description = "Address prefixes used when creating the AKS subnet"
  type        = list(string)
  default     = []
}

variable "existing_subnet_id" {
  description = "Existing subnet resource ID when create_subnet is false"
  type        = string
  default     = null
}

# ------------------------------------------------------------
# AKS
# ------------------------------------------------------------

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = null
}

variable "private_cluster_enabled" {
  description = "Whether the AKS API server should be private"
  type        = bool
  default     = false
}

variable "rbac_enabled" {
  description = "Enable Kubernetes RBAC"
  type        = bool
  default     = true
}

# ------------------------------------------------------------
# Identity
# ------------------------------------------------------------

variable "identity_type" {
  description = "AKS managed identity type"
  type        = string
  default     = "SystemAssigned"

  validation {
    condition = contains(
      ["SystemAssigned", "UserAssigned"],
      var.identity_type
    )

    error_message = "identity_type must be SystemAssigned or UserAssigned."
  }
}

variable "identity_ids" {
  description = "User-assigned managed identity resource IDs"
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------
# Networking
# ------------------------------------------------------------

variable "network_plugin" {
  description = "AKS network plugin"
  type        = string
  default     = "azure"
}

variable "network_plugin_mode" {
  description = "AKS network plugin mode"
  type        = string
  default     = "overlay"
}

variable "network_policy" {
  description = "Kubernetes network policy implementation"
  type        = string
  default     = "azure"
}

variable "pod_cidr" {
  description = "CIDR used for Kubernetes pods with overlay networking"
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  description = "CIDR used for Kubernetes Services"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address used by Kubernetes DNS"
  type        = string
  default     = "10.0.0.10"
}

# ------------------------------------------------------------
# System Node Pool
# ------------------------------------------------------------

variable "system_node_pool" {
  description = "AKS system node pool configuration"

  type = object({
    name                 = optional(string, "system")
    vm_size              = string
    auto_scaling_enabled = optional(bool, true)
    node_count           = optional(number, 1)
    min_count            = optional(number, 1)
    max_count            = optional(number, 3)
    os_disk_size_gb      = optional(number, 64)
  })
}

# ------------------------------------------------------------
# Additional Node Pools
# ------------------------------------------------------------

variable "additional_node_pools" {
  description = "Additional AKS node pools"

  type = map(object({
    vm_size              = string
    mode                 = optional(string, "User")
    auto_scaling_enabled = optional(bool, true)
    node_count           = optional(number, 1)
    min_count            = optional(number, 1)
    max_count            = optional(number, 3)
    os_disk_size_gb      = optional(number, 64)

    node_labels = optional(
      map(string),
      {}
    )

    node_taints = optional(
      list(string),
      []
    )

    tags = optional(
      map(string),
      {}
    )
  }))

  default = {}
}

# ------------------------------------------------------------
# Upgrades
# ------------------------------------------------------------

variable "automatic_upgrade_channel" {
  description = "AKS automatic Kubernetes upgrade channel"
  type        = string
  default     = "patch"
}

variable "node_os_upgrade_channel" {
  description = "AKS node OS upgrade channel"
  type        = string
  default     = "NodeImage"
}

# ------------------------------------------------------------
# Tags
# ------------------------------------------------------------

variable "tags" {
  description = "Tags applied to Azure resources"
  type        = map(string)
  default     = {}
}
