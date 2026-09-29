# ------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------

variable "create_resource_group" {
  description = "Whether Terraform should create the Resource Group"
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

# ------------------------------------------------------------
# SQL Server
# ------------------------------------------------------------

variable "create_sql_server" {
  description = "Whether Terraform should create the Azure SQL logical server"
  type        = bool
  default     = true
}

variable "sql_server_name" {
  description = "Azure SQL logical server name"
  type        = string
}

variable "existing_sql_server_id" {
  description = "Existing Azure SQL logical server resource ID"
  type        = string
  default     = null
}

variable "sql_server_version" {
  description = "Azure SQL logical server version"
  type        = string
  default     = "12.0"
}

# ------------------------------------------------------------
# SQL Authentication
# ------------------------------------------------------------

variable "administrator_login" {
  description = "SQL administrator login name"
  type        = string
}

variable "administrator_login_password" {
  description = "SQL administrator password"
  type        = string
  sensitive   = true
}

# ------------------------------------------------------------
# Microsoft Entra Administrator
# ------------------------------------------------------------

variable "azuread_administrator" {
  description = "Optional Microsoft Entra administrator"

  type = object({
    login_username              = string
    object_id                   = string
    tenant_id                   = string
    azuread_authentication_only = optional(bool, false)
  })

  default = null
}

# ------------------------------------------------------------
# Security
# ------------------------------------------------------------

variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "Enable public network access to the SQL Server"
  type        = bool
  default     = true
}

# ------------------------------------------------------------
# Databases
# ------------------------------------------------------------

variable "databases" {
  description = "Azure SQL databases"

  type = map(object({
    sku_name             = string
    max_size_gb          = optional(number)
    collation            = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    zone_redundant       = optional(bool, false)
    storage_account_type = optional(string, "Geo")
    tags                 = optional(map(string), {})
  }))

  default = {}
}

# ------------------------------------------------------------
# Tags
# ------------------------------------------------------------

variable "tags" {
  description = "Tags applied to Azure resources"
  type        = map(string)

  default = {
    ManagedBy = "terraform"
  }
}
