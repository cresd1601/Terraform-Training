output "application_url" {
  value       = "https://${azurerm_linux_web_app.application.default_hostname}"
  description = "The Web application URL."
}

output "application_hostname" {
  value       = azurerm_linux_web_app.application.default_hostname
  description = "The Web application hostname."
}

output "application_fqdn" {
  value       = azurerm_linux_web_app.application.default_hostname
  description = "The Web application fully qualified domain name (FQDN)."
}

output "application_resource_id" {
  value       = azurerm_linux_web_app.application.id
  description = "The resource ID of the Web application."
}
