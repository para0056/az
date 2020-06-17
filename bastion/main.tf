# Create Resource Group for the Bastion host
resource "azurerm_resource_group" "main" {
  name     = var.bastion_rg_name
  location = var.location
}
resource "azurerm_network_security_group" "main" {
    name = "bastion-nsg"
    location = var.location
    resource_group_name = var.bastion_rg_name

    security_rule {
    name = "ControlPlaneConnectivity"
    priority = 1001
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "GatewayManager"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_ranges = ["443","4443"]
    }

  security_rule {
    name = "allow-inbound-rcnet-443"
    priority = 1010
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = var.proxy_ip
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "443"
  }

  security_rule {
    name = "DiagnosticsLogging"
    priority = 1000
    direction = "Outbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "AzureCloud"
    destination_port_range = "443"
  }

  security_rule {
    name = "TargetVM"
    priority = 1010
    direction = "Outbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_ranges = ["22","3389"]
  }
    
}

# Create subnet for Bastion
resource "azurerm_subnet" "bastion" {
  name = "AzureBastionSubnet"
  virtual_network_name = "Dev-vnet"
  resource_group_name = var.vnet_rg_name

  address_prefix = "var.subnet_cidr"

}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.main.id
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
        subnet_id = azurerm_subnet.bastion.id
        public_ip_address_id = azurerm_public_ip.main.id
    }
}
