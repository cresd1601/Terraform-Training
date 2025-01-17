variable "resource_group_name" {
  type        = string
  description = "The resource group name"
  default     = ""
}

variable "application_name" {
  type        = string
  description = "The name of your application"
  default     = ""
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
  default     = ""
}

variable "administrator_login" {
  type        = string
  description = "The PostgreSQL administrator login"
  default     = "postgresqladmin"
}

variable "high_availability" {
  type        = bool
  description = "Enables PostgreSQL high availability"
  default     = false
}

variable "virtual_network_id" {
  type        = string
  description = "Azure Virtual Network ID"
}

variable "subnet_id" {
  type        = string
  description = "The Subnet from which the access is allowed"
}
