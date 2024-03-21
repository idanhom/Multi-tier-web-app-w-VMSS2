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
  description = "Location of the Resource Group"
  value       = data.azurerm_resource_group.rgds.location
}