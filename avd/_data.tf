data "azurerm_client_config" "current" {}

data "azurerm_subnet" "main" {
  name                 = "snet-vdi"
  virtual_network_name = "vnet-para0056-dev-vdi"
  resource_group_name  = "rg-net"
}
