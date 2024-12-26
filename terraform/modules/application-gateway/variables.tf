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

variable "application_hostname" {
  type        = string
  description = "The application hostname"
}

variable "subnet_id" {
  type        = string
  description = "The subnet from which the access is allowed"
}

variable "public_ip_address_id" {
  type        = string
  description = "The ID of the public IP address associated with the application gateway"
}

variable "vault_id" {
  type        = string
  description = "The Azure Key Vault ID"
}

variable "ssl_cert_name" {
  type        = string
  description = "The name of the SSL certificate"
}

variable "ssl_cert_key_vault_secret_id" {
  type        = string
  description = "The ID of the Key Vault secret containing the SSL certificate private key"
}

variable "probe_path" {
  type        = string
  description = "The path for the application gateway probe"
}

variable "sku_name" {
  type        = string
  description = "The SKU name of the application gateway"
}

variable "sku_tier" {
  type        = string
  description = "The SKU tier of the application gateway"
}

variable "sku_capacity" {
  type        = number
  description = "The capacity of the application gateway"
}

variable "zones" {
  type        = list(number)
  description = "The availability zones where the application gateway should be deployed"
}

variable "min_capacity" {
  type        = number
  description = "The minimum capacity of the application gateway"
}

variable "max_capacity" {
  type        = number
  description = "The maximum capacity of the application gateway"
}
