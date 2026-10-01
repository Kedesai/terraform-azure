output "management_groups" {
  description = "Created management groups keyed by the caller-defined logical key."
  value = {
    for key, group in azurerm_management_group.this : key => {
      id           = group.id
      name         = group.name
      display_name = group.display_name
    }
  }
}
