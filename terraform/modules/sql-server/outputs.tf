output "database_url" {
  value       = "${azurerm_postgresql_flexible_server.database.fqdn}:5432/${azurerm_postgresql_flexible_server_database.database.name}"
  description = "The PostgreSQL server URL."
}

output "database_host" {
  value       = azurerm_postgresql_flexible_server.database.fqdn
  description = "The PostgreSQL server host."
}

output "database_name" {
  value       = azurerm_postgresql_flexible_server_database.database.name
  description = "The PostgreSQL database name."
}

output "database_port" {
  value       = 5432 # Default PostgreSQL port
  description = "The PostgreSQL server port."
}

output "database_username" {
  value       = var.administrator_login
  description = "The PostgreSQL server user name."
}

output "database_password" {
  value       = random_password.password.result
  sensitive   = true
  description = "The PostgreSQL server password."
}
