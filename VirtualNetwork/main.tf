provider "azurerm" {
    version = "2.0.0"
    subscription_id = var.subscriptionID

    features {}
}

resource "azurerm_network_security_group" "example" {
  name                = "${var.projectName}-nsg"
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
  resource_group_name         = azurerm_network_security_group.example.resource_group_name
  network_security_group_name = azurerm_network_security_group.example.name
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
  resource_group_name         = azurerm_network_security_group.example.resource_group_name
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_virtual_network" "example-vnet" {
  name                = lower("${var.projectName}-vnet")
  location            = azurerm_network_security_group.example.location
  resource_group_name = var.resourceGroupName
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.1"]

  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "example-sub" {
  name                 = lower("${var.projectName}-subnet")
  resource_group_name  = azurerm_network_security_group.example.resource_group_name
  virtual_network_name = azurerm_virtual_network.example-vnet.name
  address_prefix       = "10.0.1.0/24"
}