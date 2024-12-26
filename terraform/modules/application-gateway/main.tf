locals {
  backend_address_pool_name      = "${var.application_name}-${var.environment}-beap"
  frontend_port_name             = "${var.application_name}-${var.environment}-feport"
  frontend_ip_configuration_name = "${var.application_name}-${var.environment}-feip"
  http_setting_name              = "${var.application_name}-${var.environment}-be-htst"
  listener_name                  = "${var.application_name}-${var.environment}-httplstn"
  request_routing_rule_name      = "${var.application_name}-${var.environment}-rqrt"
  redirect_configuration_name    = "${var.application_name}-${var.environment}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "${var.application_name}-${var.environment}-agw"
  resource_group_name = var.resource_group_name
  location            = var.location
  zones               = var.zones

  sku {
    name = var.sku_name
    tier = var.sku_tier
  }

  autoscale_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  gateway_ip_configuration {
    name      = "application-gateway-ip-configuration"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_port {
    name = "https"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_address_id
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = [var.application_hostname]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    host_name             = var.application_hostname
    cookie_based_affinity = "Disabled"
    path                  = ""
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
    probe_name            = "probe"
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = "https"
    protocol                       = "Https"
    ssl_certificate_name           = var.ssl_cert_name
  }

  redirect_configuration {
    name                 = "http-to-https-redirect"
    redirect_type        = "Permanent"
    target_listener_name = "https-listener"
    include_path         = true
    include_query_string = true
  }

  request_routing_rule {
    priority                    = 99
    name                        = "http-redirect-rule"
    rule_type                   = "Basic"
    http_listener_name          = "http-listener"
    redirect_configuration_name = "http-to-https-redirect"
  }

  request_routing_rule {
    priority                   = 100
    name                       = "https-rule"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  probe {
    name                = "probe"
    protocol            = "Https"
    path                = var.probe_path
    host                = var.application_hostname
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.base.id]
  }

  ssl_certificate {
    name                = var.ssl_cert_name
    key_vault_secret_id = var.ssl_cert_key_vault_secret_id
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = var.vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.base.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_user_assigned_identity" "base" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "appgw-keyvault-identity"
}
