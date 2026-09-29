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
# Container Registry
# ------------------------------------------------------------

variable "create_acr" {
  description = "Whether Terraform should create the Azure Container Registry"
  type        = bool
  default     = true
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
}

variable "existing_acr_id" {
  description = "Existing ACR resource ID when create_acr is false"
  type        = string
  default     = null
}

variable "sku" {
  description = "Azure Container Registry SKU"
  type        = string
  default     = "Standard"

  validation {
    condition = contains(
      ["Basic", "Standard", "Premium"],
      var.sku
    )

    error_message = "sku must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Enable the ACR admin account"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Enable public network access to ACR"
  type        = bool
  default     = true
}

# ------------------------------------------------------------
# Managed Identity
# ------------------------------------------------------------

variable "identity_type" {
  description = "Managed identity type for ACR"
  type        = string
  default     = null
}

variable "identity_ids" {
  description = "User Assigned Managed Identity resource IDs"
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------
# Role Assignments
# ------------------------------------------------------------

variable "role_assignments" {
  description = "Azure RBAC assignments scoped to the ACR"

  type = map(object({
    principal_id                     = string
    role_definition_name             = string
    skip_service_principal_aad_check = optional(bool, false)
  }))

  default = {}
}

# ------------------------------------------------------------
# Tags
# ------------------------------------------------------------

variable "tags" {
  description = "Tags applied to Azure resources"
  type        = map(string)

  default = {
    ManagedBy = "terraform"
  }
}
