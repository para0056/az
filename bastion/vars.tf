variable "location" {
  type    = string
  default = "canadacentral"
}
variable "bastion_rg_name" {
  type = string
  description = "Name of the Resource Group where the Bastion hose will reside"
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

variable "subnet_cidr" {
  type = list(string)
  description = "CIDR block for Bastion subnet"
}

variable "proxy_ip" {
    type = string
    description = "Public IP of the CRA proxy"
}
# variable "subnet_names" {
#   type = list(string)
# }
