# Subscription

# 1. My Current Subscription Display Name
output "current_subscription_display_name" {
  description = "Display Name of the Current Azure Subscription"
  value       = data.azurerm_subscription.current.display_name
}

# 2. My Current Subscription Id
output "current_subscription_id" {
  description = "ID of the Current Azure Subscription"
  value       = data.azurerm_subscription.current.subscription_id
}

# 3. My Current Subscription Spending Limit
output "current_subscription_spending_limit" {
  description = "Spending Limit of the Current Azure Subscription"
  value       = data.azurerm_subscription.current.spending_limit
}
