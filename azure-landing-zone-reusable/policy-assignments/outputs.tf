output "policy_assignments" {
  value = {
    for k, v in azurerm_management_group_policy_assignment.this : k => {
      id   = v.id
      name = v.name
    }
  }
}
