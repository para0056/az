variable "resource_group_location" {
  description = "Location of the resource group."
}

variable "rg_name" {
  type        = string
  description = "Name of the Resource group in which to deploy service objects"
}

variable "rfc3339" {
  type        = string
  default     = "2022-03-30T12:43:13Z"
  description = "Registration token expiration"
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
