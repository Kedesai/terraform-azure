module "management_groups" {
  source = "../management-groups"

  root_management_group_id = var.root_management_group_id
  management_groups        = var.management_groups
}

module "subscriptions" {
  source = "../subscriptions"

  subscription_associations = {
    for key, item in var.subscription_associations : key => {
      subscription_id     = item.subscription_id
      management_group_id = module.management_groups.management_groups[item.management_group_key].id
    }
  }
}

module "policy_assignments" {
  source = "../policy-assignments"

  policy_assignments = {
    for key, assignment in var.policy_assignments : key => {
      name                    = assignment.name
      management_group_id     = module.management_groups.management_groups[assignment.management_group_key].id
      policy_definition_id    = assignment.policy_definition_id
      display_name            = assignment.display_name
      description             = assignment.description
      enforce                 = assignment.enforce
      parameters              = assignment.parameters
      metadata                = assignment.metadata
      not_scopes              = assignment.not_scopes
      non_compliance_messages = assignment.non_compliance_messages
      location                = assignment.location
      identity_type           = assignment.identity_type
    }
  }
}
