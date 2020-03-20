variable "location" {
    type = string
    default = "canadacentral"
}

variable "vnet_rg_name" {
    type= string
}

variable "vnet_name" {
    type = string
}

variable "cidr_block" {
    type = list(string)
}

variable "subnet_names" {
    type = list(string)
}

variable "subnet_cidrs" {
    type = list(string)
}