resource "azurerm_management_group_policy_assignment" "this" {
  for_each = var.policy_assignments

  name                 = each.value.name
  management_group_id  = each.value.management_group_id
  policy_definition_id = each.value.policy_definition_id
  display_name         = each.value.display_name
  description          = each.value.description
  enforce              = each.value.enforce
  parameters           = each.value.parameters
  metadata             = each.value.metadata
  not_scopes           = each.value.not_scopes
  location             = each.value.location

  dynamic "identity" {
    for_each = each.value.identity_type == null ? [] : [each.value.identity_type]
    content {
      type = identity.value
    }
  }

  dynamic "non_compliance_message" {
    for_each = each.value.non_compliance_messages
    content {
      content = non_compliance_message.value
    }
  }
}
