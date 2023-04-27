data "azurerm_client_config" "current" {}

data "azurerm_subnet" "main" {
  name                 = "snet-vdi"
  virtual_network_name = "vnet-para0056-dev-vdi"
  resource_group_name  = "rg-net"
}

data "azurerm_role_definition" "avd_user" {
  name = "Desktop Virtualization User"
}

data "azuread_user" "avd_user" {
  user_principal_name = var.avd_user_upn
}
