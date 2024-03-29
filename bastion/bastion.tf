
# Create NSG for the Bastion Host
resource "azurerm_network_security_group" "bastion_nsg" {
  name                = "nsg-${var.prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.bastion_rg.name

  security_rule {
    name                       = "ControlPlaneConnectivity"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "GatewayManager"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = ["443", "4443"]
  }

  security_rule {
    name                       = "allow-inbound-443"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.source_ip
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "DiagnosticsLogging"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "AzureCloud"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "TargetVM"
    priority                   = 1010
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_ranges    = ["22", "3389"]
  }

  tags = var.resource_tags

}

# Create subnet for Bastion
resource "azurerm_subnet" "bastion_snet" {
  name                 = var.bastion_snet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.net.name

  address_prefixes = var.subnet_cidr
}

# Associate NSG with Bastion Subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.bastion_snet.id
  network_security_group_id = azurerm_network_security_group.bastion_nsg.id
}

# Create Public IP to be used by Bastion
resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-${var.prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.bastion_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.resource_tags

}

# Create Bastion Host
resource "azurerm_bastion_host" "main" {

  name                = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.bastion_rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_snet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = var.resource_tags
}
