# Create Resource Group for the Bastion host
resource "azurerm_resource_group" "main" {
  name     = var.bastion_name
  location = var.location
}

# Create Pubblic IP to be used by Bastion
resource "azurerm_public_ip" "main" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Creates Bastion Host
resource "azurerm_bastion_host" "main" {

    name    = var.bastion_name
    location = var.location
    resource_group_name = azurerm_resource_group.main.name

    ip_configuration {
        name = "configuration"
        subnet_id = data.azurerm_subnet.bastion.id
        public_ip_address_id = azurerm_public_ip.main.id
    }

}
