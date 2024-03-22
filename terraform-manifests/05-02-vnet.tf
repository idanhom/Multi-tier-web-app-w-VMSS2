resource "azurerm_virtual_network" "vnet" {
  name                = "${local.vnet_name}-vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}




