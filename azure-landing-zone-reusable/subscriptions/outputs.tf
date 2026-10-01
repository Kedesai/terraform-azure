output "subscription_associations" {
  value = {
    for k, v in azurerm_management_group_subscription_association.this : k => {
      management_group_id = v.management_group_id
      subscription_id     = v.subscription_id
    }
  }
}
