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