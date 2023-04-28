# Create Resource Group for resources
resource "azurerm_resource_group" "netrg" {
  name     = "rg-net"
  location = var.deploy_location
}

# Create VNet
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.prefix}"
  address_space       = var.vnet_range
  location            = var.deploy_location
  resource_group_name = azurerm_resource_group.netrg.name
  depends_on          = [azurerm_resource_group.netrg]
}

# Create subnet for AVD/VDI
resource "azurerm_subnet" "vdi" {
  name                 = "snet-vdi"
  resource_group_name  = azurerm_resource_group.netrg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_range
  depends_on           = [azurerm_resource_group.netrg]
}

# Create NSG for AVD/VDI VMs
resource "azurerm_network_security_group" "vdi" {
  name                = "nsg-${var.prefix}"
  location            = var.deploy_location
  resource_group_name = azurerm_resource_group.netrg.name
  security_rule {
    name                       = "HTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [azurerm_resource_group.netrg]
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "vdi" {
  subnet_id                 = azurerm_subnet.vdi.id
  network_security_group_id = azurerm_network_security_group.vdi.id
}
