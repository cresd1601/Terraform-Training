variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "application_name" {
  type        = string
  description = "The name of your application"
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}

variable "sku_name" {
  type        = string
  description = "The SKU name for the App Service Plan"
}

variable "os_type" {
  type        = string
  description = "The operating system type for the App Service Plan"
}

variable "https_only" {
  type        = bool
  description = "Enable HTTPS only for the Linux Web App"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public network access for the Linux Web App"
}

variable "always_on" {
  type        = bool
  description = "Enable Always On for the Linux Web App"
}

variable "health_check_path" {
  type        = string
  description = "The health check path for the Linux Web App"
}

variable "app_settings_env" {
  type        = string
  description = "Environment variables for the Linux Web App"
}

variable "app_settings_http_ports" {
  type        = number
  description = "HTTP ports for the Linux Web App"
}

variable "vault_id" {
  type        = string
  description = "The Azure Key Vault ID"
}

variable "virtual_network_id" {
  type        = string
  description = "The ID of the virtual network"
}

variable "subnet_id" {
  type        = string
  description = "The subnet the app can use"
}

variable "private_subnet_id" {
  type        = string
  description = "The subnet the app can use"
}

variable "app_insights_instrumentation_key" {
  type        = string
  description = "The Application Insights instrumentation key"
}

variable "app_insights_connection_string" {
  type        = string
  description = "The connection string for Application Insights"
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

