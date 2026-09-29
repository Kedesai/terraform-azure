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
# Key Vault
# ------------------------------------------------------------

variable "create_key_vault" {
  description = "Whether Terraform should create the Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_name" {
  description = "Azure Key Vault name"
  type        = string
}

variable "existing_key_vault_id" {
  description = "Existing Key Vault resource ID when create_key_vault is false"
  type        = string
  default     = null
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID"
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU"
  type        = string
  default     = "standard"

  validation {
    condition = contains(
      ["standard", "premium"],
      var.sku_name
    )

    error_message = "sku_name must be standard or premium."
  }
}

# ------------------------------------------------------------
# Authorization
# ------------------------------------------------------------

variable "rbac_authorization_enabled" {
  description = "Use Azure RBAC for Key Vault authorization"
  type        = bool
  default     = true
}

variable "role_assignments" {
  description = "Azure RBAC assignments scoped to the Key Vault"

  type = map(object({
    principal_id                     = string
    role_definition_name             = string
    skip_service_principal_aad_check = optional(bool, false)
  }))

  default = {}
}

# ------------------------------------------------------------
# Protection
# ------------------------------------------------------------

variable "soft_delete_retention_days" {
  description = "Number of days deleted Key Vault objects are retained"
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Enable purge protection"
  type        = bool
  default     = true
}

# ------------------------------------------------------------
# Networking
# ------------------------------------------------------------

variable "public_network_access_enabled" {
  description = "Enable public network access to Key Vault"
  type        = bool
  default     = true
}

# ------------------------------------------------------------
# Azure Integration
# ------------------------------------------------------------

variable "enabled_for_deployment" {
  description = "Allow Azure VMs to retrieve certificates stored as secrets"
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Allow Azure Disk Encryption access"
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Allow Azure Resource Manager template access"
  type        = bool
  default     = false
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
