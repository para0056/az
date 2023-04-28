variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    environment = "dev",
    source      = "terraform"
  }
}
variable "resource_group_location" {
  description = "Location of the resource group."
}

variable "rg_name" {
  type        = string
  description = "Name of the Resource group in which to deploy service objects"
}

variable "prefix" {
  type        = string
  description = "Prefix of the name of the AVD machine(s)"
}

variable "vm_size" {
  type = string
}
variable "local_admin_username" {
  type = string
}

variable "key_vault_soft_delete_retention" {
  type    = string
  default = 7
}

variable "avd_user_upn" {
  type = string
}

variable "avd_user_group_name" {
  type = string
}
