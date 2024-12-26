variable "application_name" {
  type        = string
  description = "The name of your application"
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}

variable "address_space" {
  type        = string
  description = "Virtual Network address space"
}

variable "app_gateway_subnet_prefix" {
  type        = string
  description = "Application Gateway subnet prefix"
}

variable "app_integration_subnet_prefix" {
  type        = string
  description = "Application subnet prefix"
}

variable "private_endpoint_subnet_prefix" {
  type        = string
  description = "Database subnet prefix"
}

variable "pip_zones" {
  type        = list(string)
  description = "List of availability zones for Public IP addresses"
}

variable "ssl_cert_name" {
  type        = string
  description = "The name of the SSL certificate"
}

variable "awg_zones" {
  type        = list(string)
  description = "The availability zones for the Application Gateway"
}

variable "awg_probe_path" {
  type        = string
  description = "The path for the Application Gateway probe"
}

variable "awg_sku_name" {
  type        = string
  description = "The SKU name for the Application Gateway"
}

variable "awg_sku_tier" {
  type        = string
  description = "The SKU tier for the Application Gateway"
}

variable "awg_sku_capacity" {
  type        = number
  description = "The SKU capacity for the Application Gateway"
}

variable "awg_min_capacity" {
  type        = number
  description = "The minimum capacity for the Application Gateway"
}

variable "awg_max_capacity" {
  type        = number
  description = "The maximum capacity for the Application Gateway"
}

variable "appservice_plan_sku_name" {
  type        = string
  description = "The SKU name for the App Service Plan"
}

variable "appservice_plan_os_type" {
  type        = string
  description = "The operating system type for the App Service Plan"
}

variable "appservice_https_only" {
  type        = bool
  description = "Enable HTTPS only for the Linux Web App"
}

variable "appservice_public_network_access_enabled" {
  type        = bool
  description = "Enable public network access for the Linux Web App"
}

variable "appservice_always_on" {
  type        = bool
  description = "Enable Always On for the Linux Web App"
}

variable "appservice_health_check_path" {
  type        = string
  description = "The health check path for the Linux Web App"
}

variable "appservice_app_settings_env" {
  type        = string
  description = "Environment variables for the Linux Web App"
}

variable "appservice_app_settings_http_ports" {
  type        = number
  description = "HTTP ports for the Linux Web App"
}

variable "analytics_workspace_sku" {
  type        = string
  description = "The SKU (pricing tier) of the Azure Monitor Analytics workspace"
}

variable "analytics_workspace_retention_in_days" {
  type        = number
  description = "The number of days to retain data in the Azure Monitor Analytics workspace"
}

variable "keyvault_sku_name" {
  type        = string
  description = "The SKU name for the keyvault"
}

variable "docker_image_name" {
  type        = string
  description = "The name of the Docker image"
}

variable "docker_registry_url" {
  type        = string
  description = "The URL of the Docker registry"
}

variable "docker_registry_username" {
  type        = string
  description = "The username for the Docker registry"
}

variable "docker_registry_password" {
  type        = string
  description = "The password for the Docker registry"
}
