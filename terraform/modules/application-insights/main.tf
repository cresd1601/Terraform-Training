resource "azurerm_log_analytics_workspace" "application" {
  name                = "${var.application_name}-${var.environment}-law"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku               # e.g., "PerGB2018"
  retention_in_days   = var.retention_in_days # e.g., 30
}

resource "azurerm_application_insights" "application" {
  name                = "${var.application_name}-${var.environment}-ai"
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = "web"
}

resource "azurerm_monitor_diagnostic_setting" "application" {
  name                       = "${var.application_name}-${var.environment}-ds"
  target_resource_id         = var.application_resource_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.application.id

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServicePlatformLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
