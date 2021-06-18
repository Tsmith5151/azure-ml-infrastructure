provider "azurerm" {
    version = "2.0.0"
    subscription_id = var.subscriptionID

    features {}
}

resource "azurerm_network_security_group" "machine-learning" {
  name                = "MachineLearningNSG"
  location            = var.location
  resource_group_name = var.resourceGroupName
}

resource "azurerm_network_security_rule" "Port80" {
  name                        = "Allow80"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.machine-learning.resource_group_name
  network_security_group_name = azurerm_network_security_group.machine-learning.name
}

resource "azurerm_network_security_rule" "Port443" {
  name                        = "Allow443"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.machine-learning.resource_group_name
  network_security_group_name = azurerm_network_security_group.machine-learning.name
}

resource "azurerm_virtual_network" "machine-learning-vnet" {
  name                = "example-vnet"
  location            = azurerm_network_security_group.machine-learning.location
  resource_group_name = var.resourceGroupName
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_subnet" "example-sub" {
  name                 = "testsubnet"
  resource_group_name  = azurerm_network_security_group.machine-learning.resource_group_name
  virtual_network_name = azurerm_virtual_network.machine-learning-vnet.name
  address_prefix       = "10.0.1.0/24"
}