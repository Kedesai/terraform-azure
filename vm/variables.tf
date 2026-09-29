# ------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------

variable "create_resource_group" {
  description = "Whether Terraform should create the Resource Group"
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

# ------------------------------------------------------------
# VM
# ------------------------------------------------------------

variable "vm_name" {
  description = "Linux VM name"
  type        = string
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "zone" {
  description = "Availability Zone"
  type        = string
  default     = null
}

variable "admin_username" {
  description = "Linux administrator username"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key used for VM authentication"
  type        = string
}

# ------------------------------------------------------------
# Networking
# ------------------------------------------------------------

variable "subnet_id" {
  description = "Existing subnet resource ID"
  type        = string
}

variable "network_security_group_id" {
  description = "Optional NSG resource ID to associate with the VM NIC"
  type        = string
  default     = null
}

variable "private_ip_address_allocation" {
  description = "Private IP allocation method"
  type        = string
  default     = "Dynamic"

  validation {
    condition = contains(
      ["Dynamic", "Static"],
      var.private_ip_address_allocation
    )

    error_message = "private_ip_address_allocation must be Dynamic or Static."
  }
}

variable "private_ip_address" {
  description = "Static private IP address"
  type        = string
  default     = null
}

variable "accelerated_networking_enabled" {
  description = "Enable accelerated networking on the NIC"
  type        = bool
  default     = false
}

# ------------------------------------------------------------
# Managed Identity
# ------------------------------------------------------------

variable "identity_type" {
  description = "Managed identity type"
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "User Assigned Managed Identity resource IDs"
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------
# OS Image
# ------------------------------------------------------------

variable "source_image" {
  description = "Azure Marketplace source image"

  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# ------------------------------------------------------------
# OS Disk
# ------------------------------------------------------------

variable "os_disk_type" {
  description = "OS disk storage type"
  type        = string
  default     = "Premium_LRS"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 64
}

variable "os_disk_caching" {
  description = "OS disk caching mode"
  type        = string
  default     = "ReadWrite"
}

# ------------------------------------------------------------
# Data Disks
# ------------------------------------------------------------

variable "data_disks" {
  description = "Managed data disks attached to the VM"

  type = map(object({
    disk_size_gb         = number
    lun                  = number
    storage_account_type = optional(string, "Premium_LRS")
    caching              = optional(string, "ReadWrite")
  }))

  default = {}
}

# ------------------------------------------------------------
# Tags
# ------------------------------------------------------------

variable "tags" {
  description = "Tags applied to resources"
  type        = map(string)

  default = {
    ManagedBy = "terraform"
  }
}
