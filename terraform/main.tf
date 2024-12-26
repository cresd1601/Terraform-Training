terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.93.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "http" "myip" {
  url = "http://whatismyip.akamai.com"
}

locals {
  environment = var.environment == "" ? "dev" : var.environment
  myip        = chomp(data.http.myip.response_body)
}

resource "azurerm_resource_group" "main" {
  name     = "${var.application_name}-${local.environment}-rg"
  location = var.location

  tags = {
    environment      = local.environment
    application-name = var.application_name
  }
}

module "application" {
  source              = "./modules/app-service"
  resource_group_name = azurerm_resource_group.main.name
  application_name    = var.application_name
  environment         = local.environment
  location            = var.location

  sku_name = var.appservice_plan_sku_name
  os_type  = var.appservice_plan_os_type

  always_on         = var.appservice_always_on
  health_check_path = var.appservice_health_check_path

  app_settings_env        = var.appservice_app_settings_env
  app_settings_http_ports = var.appservice_app_settings_http_ports

  https_only                    = var.appservice_https_only
  public_network_access_enabled = var.appservice_public_network_access_enabled

  vault_id = module.key-vault.vault_id

  virtual_network_id = module.network.virtual_network_id
  subnet_id          = module.network.app_subnet_id
  private_subnet_id  = module.network.private_endpoint_subnet_id

  app_insights_instrumentation_key = module.application-insights.instrumentation_key
  app_insights_connection_string   = module.application-insights.connection_string

  docker_image_name        = var.docker_image_name
  docker_registry_url      = var.docker_registry_url
  docker_registry_username = var.docker_registry_username
  docker_registry_password = var.docker_registry_password
}

module "sql-server" {
  source              = "./modules/sql-server"
  resource_group_name = azurerm_resource_group.main.name
  application_name    = var.application_name
  environment         = local.environment
  location            = var.location
  high_availability   = false

  virtual_network_id = module.network.virtual_network_id
  subnet_id          = module.network.private_endpoint_subnet_id
}

module "key-vault" {
  source              = "./modules/key-vault"
  resource_group_name = azurerm_resource_group.main.name
  application_name    = var.application_name
  environment         = local.environment
  location            = var.location

  virtual_network_id = module.network.virtual_network_id
  subnet_id          = module.network.private_endpoint_subnet_id

  sku_name           = var.keyvault_sku_name
  cert_contents_path = filebase64("./cert/az-terraform.pfx")
  cert_pwd_path      = file("./cert/password.txt")
  myip               = local.myip
}

module "network" {
  source                    = "./modules/virtual-network"
  resource_group_name       = azurerm_resource_group.main.name
  application_name          = var.application_name
  environment               = local.environment
  location                  = var.location
  app_gateway_subnet_prefix = var.app_gateway_subnet_prefix

  address_space                 = var.address_space
  app_integration_subnet_prefix = var.app_integration_subnet_prefix

  private_endpoint_subnet_prefix = var.private_endpoint_subnet_prefix

  pip_zones = var.pip_zones
}

module "application-insights" {
  source                  = "./modules/application-insights"
  resource_group_name     = azurerm_resource_group.main.name
  application_name        = var.application_name
  environment             = local.environment
  location                = var.location
  application_resource_id = module.application.application_resource_id
  sku                     = var.analytics_workspace_sku
  retention_in_days       = var.analytics_workspace_retention_in_days
}

module "application-gateway" {
  source                       = "./modules/application-gateway"
  resource_group_name          = azurerm_resource_group.main.name
  application_name             = var.application_name
  environment                  = local.environment
  location                     = var.location
  application_hostname         = module.application.application_hostname
  subnet_id                    = module.network.application_gateway_subnet_id
  public_ip_address_id         = module.network.public_ip_address_id
  ssl_cert_name                = var.ssl_cert_name
  vault_id                     = module.key-vault.vault_id
  ssl_cert_key_vault_secret_id = module.key-vault.vault_certificate_secret_id
  probe_path                   = var.awg_probe_path
  sku_name                     = var.awg_sku_name
  sku_tier                     = var.awg_sku_tier
  sku_capacity                 = var.awg_sku_capacity
  zones                        = var.awg_zones
  min_capacity                 = var.awg_min_capacity
  max_capacity                 = var.awg_max_capacity
}
