
resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.application_name}-${var.environment}-vnet"
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment      = var.environment
    application-name = var.application_name
  }
}

resource "azurerm_subnet" "application_gateway_subnet" {
  name                 = "${var.application_name}-${var.environment}-vnet-gateway"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.app_gateway_subnet_prefix]
}

resource "azurerm_public_ip" "virtual_network" {
  name                = "${var.application_name}-${var.environment}-vnet-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.pip_zones
}

resource "azurerm_subnet" "app_integration_subnet" {
  name                 = "${var.application_name}-${var.environment}-app-integration-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.app_integration_subnet_prefix]

  delegation {
    name = "app-integration-subnet"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "${var.application_name}-${var.environment}-vnet-private-endpoint"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.private_endpoint_subnet_prefix]

  private_endpoint_network_policies_enabled = true
}
