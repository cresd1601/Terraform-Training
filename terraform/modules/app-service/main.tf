resource "azurerm_service_plan" "application" {
  name                = "${var.application_name}-${var.environment}-asp"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name
  os_type             = var.os_type

  tags = {
    environment      = var.environment
    application_name = var.application_name
  }
}

resource "azurerm_linux_web_app" "application" {
  name                          = "${var.application_name}-${var.environment}-app"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.application.id
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.subnet_id

  tags = {
    environment      = var.environment
    application_name = var.application_name
  }

  site_config {
    always_on         = var.always_on
    health_check_path = var.health_check_path

    application_stack {
      docker_image_name        = var.docker_image_name
      docker_registry_url      = var.docker_registry_url
      docker_registry_username = var.docker_registry_username
      docker_registry_password = var.docker_registry_password
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    DATABASE_CONNECTION_STRING = "Host=practice-stag-db.postgres.database.azure.com;Port=5432;Database=practice-stag-db;Username=postgresqladmin;Password=i@@8INX9kwufZQst59eKtEybJz@g8sLY;Include Error Detail=true"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "application" {
  key_vault_id = var.vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.application.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_private_endpoint" "endpoint" {
  name                = "${var.application_name}-${var.environment}-app-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.private_subnet_id

  private_service_connection {
    name                           = "${var.application_name}-${var.environment}-psc"
    private_connection_resource_id = azurerm_linux_web_app.application.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.application_name}-${var.environment}-dnszg"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "${var.application_name}-${var.environment}-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
}
