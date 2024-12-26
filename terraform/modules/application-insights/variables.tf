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
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}

variable "application_resource_id" {
  type        = string
  description = "The resource ID of the application"
}

variable "sku" {
  type        = string
  description = "The SKU (pricing tier) of the Azure Monitor Analytics workspace"
}

variable "retention_in_days" {
  type        = number
  description = "The number of days to retain data in the Azure Monitor Analytics workspace"
}
