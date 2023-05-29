terraform {
    backend "azurerm"{ 
        resource_group_name = "DevTestRG"
        storage_account_name = "devstatefileaccount"
        container_name = "tfstate"
        key = "vnet-terraform.state"
    }
}
provider "azurerm" {
  version = "~> 2.0"
  skip_provider_registration = "true"
  features {}
}

data "azurerm_resource_group" "resource_group_name" {
  name = "${var.name}RG"
}

resource "azurerm_virtual_network" "aks_virtual_network" {
   name = "${var.name}lagosvnet"
   location = var.location
   resource_group_name = data.azurerm_resource_group.resource_group_name.name
   address_space = [var.network_address_space]
}

resource "azurerm_subnet" "aks_subnet" {
  name = var.aks_subnet_address_name
  resource_group_name  = data.azurerm_resource_group.resource_group_name.name
  virtual_network_name = azurerm_virtual_network.aks_virtual_network.name
  address_prefixes = [var.aks_subnet_address_prefix]
}

resource "azurerm_subnet" "app_gwsubnet" {
  name = var.subnet_address_name
  resource_group_name  = data.azurerm_resource_group.resource_group_name.name
  virtual_network_name = azurerm_virtual_network.aks_virtual_network.name
  address_prefixes = [var.subnet_address_prefix]
}