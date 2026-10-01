variable "policy_assignments" {
  description = "Azure Policy assignments scoped at management groups."
  type = map(object({
    name                    = string
    management_group_id     = string
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
