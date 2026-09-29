output "sql_server_id" {
  description = "Azure SQL logical server resource ID"
  value       = local.sql_server_id
}

output "sql_server_name" {
  description = "Azure SQL logical server name"
  value       = var.sql_server_name
}

output "sql_server_fqdn" {
  description = "Azure SQL logical server FQDN"

  value = (
    var.create_sql_server
    ? azurerm_mssql_server.this[0].fully_qualified_domain_name
    : null
  )
}

output "database_ids" {
  description = "Azure SQL Database resource IDs"

  value = {
    for name, database in azurerm_mssql_database.this :
    name => database.id
  }
}

output "database_names" {
  description = "Azure SQL Database names"

  value = keys(azurerm_mssql_database.this)
}

output "resource_group_name" {
  description = "Resource Group"
  value       = local.resource_group_name
}
