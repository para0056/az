terraform {
  backend "azurerm" {
    resource_group_name  = "rg-para0056-tfstate"
    storage_account_name = "terraformm2qz09dls6hme03"
    container_name       = "tfstate"
    key                  = "avd.tfstate"

  }
}
