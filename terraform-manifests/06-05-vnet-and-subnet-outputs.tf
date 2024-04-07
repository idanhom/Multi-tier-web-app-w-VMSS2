# Output Virtual Network
output "virtual_network_name" {
  description = "Virtual Network Name"
  value       = data.azurerm_virtual_network.vnetds.id
}

output "ds_vnet_address_space" {
  description = "Address Space of the Virtual Network"
  value       = data.azurerm_virtual_network.vnetds.address_space
}