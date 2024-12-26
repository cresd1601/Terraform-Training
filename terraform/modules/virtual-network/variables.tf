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

variable "address_space" {
  type        = string
  description = "VNet address space"
}

variable "app_integration_subnet_prefix" {
  type        = string
  description = "Application subnet prefix"
}

variable "private_endpoint_subnet_prefix" {
  type        = string
  description = "Azure Private Endpoint subnet prefix"
}

variable "app_gateway_subnet_prefix" {
  type        = string
  description = "Application Gateway subnet prefix"
}

variable "pip_zones" {
  type        = list(string)
  description = "List of availability zones for Public IP addresses"
}
