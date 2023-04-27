variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    environment = "dev",
    source      = "terraform"
  }
}
variable "location" {
  type    = string
  default = "canadacentral"
}

variable "prefix" {
  type        = string
  description = "Generic name of resources"
}
variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "vnet_rg_name" {
  type        = string
  description = "Name of the Networking Resource Group"
}

variable "subnet_cidr" {
  type        = list(string)
  description = "CIDR block for Bastion subnet"
}

variable "proxy_ip" {
  type        = string
  description = "Public IP to allow"
}
