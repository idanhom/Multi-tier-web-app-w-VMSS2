# Subscription

# My Current Subscription Display Name
output "current_subscription_display_name" {
  description = "Display Name of the Current Azure Subscription"
  value       = data.azurerm_subscription.current.display_name
}

# My Current Subscription Id
output "current_subscription_id" {
  description = "ID of the Current Azure Subscription"
  value       = data.azurerm_subscription.current.subscription_id
}

# My Current Subscription Spending Limit
output "current_subscription_spending_limit" {
  description = "Spending Limit of the Current Azure Subscription"
  value       = data.azurerm_subscription.current.spending_limit
}


# here we should have application gateway ip... perhaps...
# unsure, currently


# output "public_ip_address" {
#   description = "Public IP of web-linuxvm"
#   value = azurerm_public_ip.publicip.ip_address
# }


