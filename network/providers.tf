terraform {
  required_providers {
    azuread = {
      version = "~> 2.36.0"
      source  = "hashicorp/azuread"
    }
    azurerm = {
      version = "~> 3.51.0"
      source  = "hashicorp/azurerm"

    }
    local = {
      version = "~> 2.4.0"
      source  = "hashicorp/local"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }
}

provider "azurerm" {
  features {

  }
}
