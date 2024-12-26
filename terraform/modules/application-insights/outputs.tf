output "instrumentation_key" {
  value = azurerm_application_insights.application.instrumentation_key
}

output "connection_string" {
  value = azurerm_application_insights.application.connection_string
}
