# Output Reference Group
output "resource_group_id" {
  description = "Resource Group ID"
  value       = data.azurerm_resource_group.rgds.id
}

output "resource_group_name" {
  description = "Resource Group name"
  value       = data.azurerm_resource_group.rgds.name
}

output "ds_rg_location" {
  value = data.azurerm_resource_group.rgds.location
}

# Output Virtual Network
output "virtual_network_name" {
  description = "Virtual Network Name"
  value       = data.azurerm_virtual_network.vnetds.id
}

output "ds_vnet_address_space" {
  value = data.azurerm_virtual_network.vnetds.address_space
}

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
