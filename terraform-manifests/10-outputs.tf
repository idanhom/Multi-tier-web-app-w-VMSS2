# Output Reference Group
output "resource_group_id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.rg.id
}
output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.rg.name
}

# Output Virtual Network
output "virtual_network_name" {
  description = "Virutal Network Name"
  value       = azurerm_virtual_network.myvnet.id
}
# ------------------------
# From 06-datasource, rg
# 1. Resource Group Name from Datasource
output "ds_rg_name" {
  value = data.azurerm_resource_group.rgds.name
}

# 2. Resource Group Location from Datasource
output "ds_rg_location" {
  value = data.azurerm_resource_group.rgds.location
}

# 3. Resource Group ID from Datasource
output "ds_rg_id" {
  value = data.azurerm_resource_group.rgds.id
}
# -------------------
# From 06-datasource, vnet

# 1. Virtual Network Name from Datasource
output "ds_vnet_name" {
  value = data.azurerm_virtual_network.vnetds
}

# 2. Virtual Network ID from Datasource
output "ds_vnet_id" {
  value = data.azurerm_virtual_network.vnetds.id
}

# 3. Virtual Network address_space from Datasource
output "ds_vnet_address_space" {
  value = data.azurerm_virtual_network.vnetds.address_space
}

# --------------

# Subscription

# 1. My Current Subscription Display Name
output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

# 2. My Current Subscription Id
output "current_subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

# 3. My Current Subscription Spending Limit
output "current_subscription_spending_limit" {
  value = data.azurerm_subscription.current.spending_limit
}
