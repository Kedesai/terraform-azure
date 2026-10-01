resource "azurerm_management_group" "this" {
  for_each = var.management_groups

  name         = each.value.name
  display_name = each.value.display_name

  parent_management_group_id = each.value.parent_key == null ? var.root_management_group_id : azurerm_management_group.this[each.value.parent_key].id
}
