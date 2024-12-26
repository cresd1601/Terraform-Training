output "virtual_network_id" {
  value       = azurerm_virtual_network.virtual_network.id
  description = "Application Virtual Network"
}

output "app_subnet_id" {
  value       = azurerm_subnet.app_integration_subnet.id
  description = "Application Subnet"
}

output "private_endpoint_subnet_id" {
  value       = azurerm_subnet.private_endpoint_subnet.id
  description = "Database subnet"
}

output "application_gateway_subnet_id" {
  value       = azurerm_subnet.application_gateway_subnet.id
  description = "Application Subnet"
}

output "public_ip_address_id" {
  value       = azurerm_public_ip.virtual_network.id
  description = "Public IP Address ID for vnet"
}
