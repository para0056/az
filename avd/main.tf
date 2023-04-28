# Create Resource Group for AVD
resource "azurerm_resource_group" "main" {
  name     = var.rg_name
  location = var.resource_group_location
  tags     = var.resource_tags

}