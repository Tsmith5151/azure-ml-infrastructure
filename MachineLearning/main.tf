provider "azurerm" {
    version = "~> 2.6.0"
    subscription_id = var.subscriptionID

    features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resourceGroupName
  location = var.location
}

data "azuread_service_principal" "example" {
  display_name = lower("${var.projectName}-sp")
}

data "azurerm_client_config" "current" {
}

output "tennant_id" {
  value = data.azurerm_client_config.current.client_id
}

resource "azurerm_application_insights" "example" {
  name                = lower("${var.projectName}-appi")  
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

resource "azurerm_key_vault" "example" {
  name                = lower("${var.projectName}-keyvault")
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_storage_account" "example" {
  name                     = lower("${var.projectName}store")
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_container_registry" "example" {
  name                     = lower("${var.projectName}acr")
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  sku                      = "Premium"
  admin_enabled            = true
  georeplication_locations = ["East US2"]
}

resource "azurerm_machine_learning_workspace" "example" {
  name                    = lower("${var.projectName}-aml")
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id
  container_registry_id   = azurerm_container_registry.example.id

  identity {
    type = "SystemAssigned"
  }
}


