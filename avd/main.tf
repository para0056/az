# Resource group name is output when execution plan is applied.
resource "azurerm_resource_group" "main" {
  name     = var.rg_name
  location = var.resource_group_location
  tags = {
    "tfmanaged" = "true"
  }
}