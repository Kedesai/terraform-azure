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
# Managed Identity
# ------------------------------------------------------------

variable "create_identity" {
  description = "Whether Terraform should create the User Assigned Managed Identity"
  type        = bool
  default     = true
}

variable "identity_name" {
  description = "User Assigned Managed Identity name"
  type        = string
}

variable "existing_identity_id" {
  description = "Existing User Assigned Managed Identity resource ID"
  type        = string
  default     = null
}

# ------------------------------------------------------------
# Role Assignments
# ------------------------------------------------------------

variable "role_assignments" {
  description = "Azure RBAC role assignments for the managed identity"

  type = map(object({
    scope                = string
    role_definition_name = string
  }))

  default = {}
}

# ------------------------------------------------------------
# Tags
# ------------------------------------------------------------

variable "tags" {
  description = "Tags applied to resources"
  type        = map(string)
  default     = {}
}
