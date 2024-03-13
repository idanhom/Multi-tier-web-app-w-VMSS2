terraform {
  backend "azurerm" {
    resource_group_name  = "demo"
    storage_account_name = "tfstate1231"
    container_name       = "tfstate"
    key                  = "demo.terraform.tfstate"
  }
}