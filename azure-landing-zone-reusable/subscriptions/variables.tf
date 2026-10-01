variable "subscription_associations" {
  description = "Existing Azure subscriptions associated with management groups."
  type = map(object({
    management_group_id = string
    subscription_id     = string
  }))
  default = {}
}
