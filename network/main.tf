resource "azurerm_resource_group" "main" {
  name     = "networking-msdn-rg"
  location = var.location
}
