data "terraform_remote_state" "remote_state" {
  backend = "azurerm"

  config = {
    resource_group_name  = "demo"
    storage_account_name = "tfstate1231"
    container_name       = "tfstate"
    key                  = "demo.terraform.tfstate"
  }



}