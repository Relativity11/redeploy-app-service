# Define variables
variable "resource_group_name" {
  description = "The name of the resource group"
}

variable "location" {
  description = "The location of the resources"
}

variable "app_service_name" {
  description = "The name of the App Service"
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan"
}

variable "storage_account_name" {
  description = "The name of the existing storage account"
}

variable "storage_container_name" {
  description = "The name of the existing storage container"
}

variable "subscription_id" {
  description = "The subscription ID"
}