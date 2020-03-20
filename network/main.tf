# Create Resource Group to contain network resources
resource "azurerm_resource_group" "main" {
  name     = "network_rg_name"
  location = var.location
}

# Create Virtual Network
resource "azurerm_virtual_network" "example"{
  name    = var.vnet_name
  location = var.location
  resource_group_name = var.vnet_rg_name
  address_space = var.cidr_bock
}

resource "azurerm_subnet" "main" {
  count = length(var.subnet_names)

  name = element(var.subnet_names, count.index)
  resource_group_name = var.vnet_rg_name
  virtual_network_name = var.vnet_name
  address_prefix = element(var.subnet_cidrs, count.index)
}