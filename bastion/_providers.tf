terraform {
  required_providers {
    azurerm = {
      version = "~> 3.53.0"
      source  = "hashicorp/azurerm"

    }
  }
}

provider "azurerm" {
  features {

  }
}
