variable "location" {
  type    = string
  default = "canadacentral"
}

variable "bastion_name" {
  type        = string
  description = "Name of the Bastion Host"
}

variable "pip_name" {
  type        = string
  description = "Name of the Public IP to be used by Azure Bastion"
}

variable "vnet_name" {
    type = string
    description = "Name of the Virtual Network"
}

variable "vnet_rg_name" {
    type= string
    description = "Name of the Networking Resource Group"
}

variable "subnet_names" {
  type = list(string)
}
