# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Linux App Service Plan using the new azurerm_service_plan resource
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "P1v3"
}

# Create an App Service for a container
resource "azurerm_app_service" "app" {
  name                = var.app_service_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_service_plan.asp.id

  site_config {
    linux_fx_version = "DOCKER|nginx:latest"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}

# Reference the existing storage account
data "azurerm_storage_account" "existing" {
  name                = var.storage_account_name
  resource_group_name = "persistent-storage-rg"
}

# Reference the existing storage container
data "azurerm_storage_container" "existing_container" {
  name                  = var.storage_container_name
  storage_account_name  = data.azurerm_storage_account.existing.name
}

resource "azurerm_app_service_slot" "slot" {
  name                = "dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_service_plan.asp.id
  app_service_name    = azurerm_app_service.app.name

  site_config {
    linux_fx_version = "DOCKER|nginx:latest"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "AzureWebJobsStorage"      = data.azurerm_storage_account.existing.primary_connection_string
  }

  depends_on = [
    azurerm_app_service.app
  ]
}