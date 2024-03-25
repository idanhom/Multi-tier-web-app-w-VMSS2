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


# output "public_ip_address" {
#   description = "Public IP of web-linuxvm"
#   value = azurerm_public_ip.publicip.ip_address
# }

# LB Public IP
output "web_lb_public_ip_address" {
  description = "Web Load Balancer Public Address"
  value = azurerm_public_ip.publicip.ip_address
}

# Load Balancer ID
output "web_lb_id" {
  description = "Web Load Balancer ID."
  value = azurerm_lb.web_lb.id
}

# Load Balancer Frontend IP Configuration Block
output "web_lb_frontend_ip_configuration" {
  description = "Web LB frontend_ip_configuration Block"
  value = [azurerm_lb.web_lb.frontend_ip_configuration]
}