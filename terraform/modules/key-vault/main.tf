data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "application" {
  name                = "${var.application_name}-${var.environment}-kv"
  resource_group_name = var.resource_group_name
  location            = var.location

  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = var.sku_name

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = [var.myip]
  }

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = azurerm_key_vault.application.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Set",
    "Get",
    "List",
    "Delete",
    "Purge"
  ]

  certificate_permissions = [
    "Create",
    "Get",
    "List",
    "Delete",
    "Import",
    "Purge"
  ]
}

resource "azurerm_key_vault_certificate" "application" {
  name         = "${var.application_name}-${var.environment}-imp-cert"
  key_vault_id = azurerm_key_vault.application.id

  certificate {
    contents = var.cert_contents_path
    password = var.cert_pwd_path
  }

  depends_on = [azurerm_key_vault_access_policy.client]
}

resource "azurerm_private_endpoint" "keyvault_endpoint" {
  name                = "${var.application_name}-${var.environment}-kv-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.application_name}-${var.environment}-psc"
    private_connection_resource_id = azurerm_key_vault.application.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.application_name}-${var.environment}-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "keyvault_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "my_terraform_vnet_link" {
  name                  = "${var.application_name}-${var.environment}-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault_dns_zone.name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
}
