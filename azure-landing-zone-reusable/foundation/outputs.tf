output "management_groups" {
  value = module.management_groups.management_groups
}

output "subscription_associations" {
  value = module.subscriptions.subscription_associations
}

output "policy_assignments" {
  value = module.policy_assignments.policy_assignments
}
