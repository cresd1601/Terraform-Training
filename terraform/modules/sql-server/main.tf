resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_postgresql_flexible_server" "database" {
  name                = "${var.application_name}-${var.environment}-db"
  resource_group_name = var.resource_group_name
  location            = var.location

  administrator_login    = var.administrator_login
  administrator_password = random_password.password.result

  sku_name              = "GP_Standard_D2ds_v5"
  storage_mb            = 32768
  backup_retention_days = 7
  version               = "14"
  zone                  = "1"

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = "${var.application_name}-${var.environment}-db"
  server_id = azurerm_postgresql_flexible_server.database.id
  charset   = "utf8"
  collation = "en_US.utf8"
}

resource "azurerm_private_endpoint" "database_service_endpoint" {
  name                = "${var.application_name}-${var.environment}-db-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.application_name}-${var.environment}-psc"
    private_connection_resource_id = azurerm_postgresql_flexible_server.database.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.application_name}-${var.environment}-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.database.id]
  }
}

resource "azurerm_private_dns_zone" "database" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "database" {
  name                  = "${var.application_name}-${var.environment}-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.database.name
  virtual_network_id    = var.virtual_network_id
}
