variable "resource_group_name" {
  type        = string
  description = "The resource group"
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

variable "subnet_id" {
  type        = string
  description = "The subnet from which the access is allowed"
}

variable "myip" {
  type        = string
  description = "The IP address of the current client. It is required to provide access to this client to be able to create the secrets"
}

variable "virtual_network_id" {
  type        = string
  description = "The ID of the virtual network"
}

variable "sku_name" {
  type        = string
  description = "The SKU name for the keyvault"
}

variable "cert_contents_path" {
  type        = string
  description = "The path to the certificate contents file"
}

variable "cert_pwd_path" {
  type        = string
  description = "The path to the certificate password file"
}
