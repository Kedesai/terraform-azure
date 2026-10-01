variable "root_management_group_id" {
  description = "Existing tenant root or intermediate management group resource ID."
  type        = string
}

variable "management_groups" {
  description = "Management-group hierarchy. parent_key is null for groups directly below the existing root."
  type = map(object({
    name         = string
    display_name = string
    parent_key   = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for key, group in var.management_groups :
      group.parent_key == null || (group.parent_key != key && contains(keys(var.management_groups), group.parent_key))
    ])
    error_message = "Each parent_key must reference another management_groups key and cannot reference itself."
  }
}

variable "subscription_associations" {
  type = map(object({ subscription_id = string, management_group_key = string }))
  default = {}
  validation {
    condition     = alltrue([for item in values(var.subscription_associations) : contains(keys(var.management_groups), item.management_group_key)])
    error_message = "Every subscription management_group_key must identify an entry in management_groups."
  }
}

variable "policy_assignments" {
  type = map(object({
    name                    = string
    management_group_key    = string
    policy_definition_id    = string
    display_name            = optional(string)
    description             = optional(string)
    enforce                 = optional(bool, true)
    parameters              = optional(string)
    metadata                = optional(string)
    not_scopes              = optional(list(string), [])
    non_compliance_messages = optional(list(string), [])
    location                = optional(string)
    identity_type           = optional(string)
  }))
  default = {}

  validation {
    condition     = alltrue([for assignment in values(var.policy_assignments) : contains(keys(var.management_groups), assignment.management_group_key)])
    error_message = "Every policy assignment management_group_key must identify an entry in management_groups."
  }
  validation {
    condition     = alltrue([for assignment in values(var.policy_assignments) : length(assignment.name) <= 24])
    error_message = "Management-group Policy Assignment names cannot exceed 24 characters."
  }
  validation {
    condition = alltrue([
      for assignment in values(var.policy_assignments) :
      assignment.identity_type == null || (assignment.identity_type == "SystemAssigned" && assignment.location != null)
    ])
    error_message = "When identity_type is set, use SystemAssigned and specify location."
  }
}
