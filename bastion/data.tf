data "azurerm_subnet" "bastion" {
    name = var.subnet_names[3]
    virtual_network_name = var.vnet_name
    resource_group_name = var.vnet_rg_name
}

output "subnet_id" {
    value = data.azurerm_subnet.bastion.id
}
