# Datasource rg
data "azurerm_resource_group" "rgds" {
  depends_on = [azurerm_resource_group.rg]
  name       = local.rg_name
}

# Datasources
data "azurerm_virtual_network" "vnetds" {
  depends_on          = [azurerm_virtual_network.vnet]
  name                = "${local.vnet_name}-vnet"
  resource_group_name = local.rg_name
}

#Subscription
data "azurerm_subscription" "current" {
}