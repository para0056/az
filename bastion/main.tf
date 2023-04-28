# Create Resource Group for the Bastion host
resource "azurerm_resource_group" "bastion_rg" {
  name     = "rg-${var.prefix}"
  location = var.location

  tags = var.resource_tags
}
