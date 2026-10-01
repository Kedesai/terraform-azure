variable "root_management_group_id" {
  description = "Existing tenant root or intermediate management group resource ID."
  type        = string
}

variable "management_groups" {
  description = "Management-group hierarchy. parent_key is null for groups directly below root_management_group_id."
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
