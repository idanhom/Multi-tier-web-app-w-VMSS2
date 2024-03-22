resource "azurerm_resource_group" "rg" {
  name     = "${local.rg_name}-rg"
  location = var.resource_group_location
}

