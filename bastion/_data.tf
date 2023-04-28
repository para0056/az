data "azurerm_virtual_network" "net" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.net.name
}

data "azurerm_resource_group" "net" {
  name = var.vnet_rg_name
}
