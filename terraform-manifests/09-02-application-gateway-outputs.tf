# Application Gateway Outputs
output "web_ag_id" {
  description = "Azure Application Gateway ID"  
  value = azurerm_application_gateway.web_ag.id 
}

output "web_ag_public_ip_1" {
  description = "Azure Application Gateway Public IP 1"  
  value = azurerm_public_ip.web_ag_publicip.ip_address
}

output "app1_backend_address_pool_id" {
  value = tolist([for pool in azurerm_application_gateway.web_ag.backend_address_pool : pool.id if pool.name == local.backend_address_pool_name_app1])[0]
}

output "app2_backend_address_pool_id" {
  value = tolist([for pool in azurerm_application_gateway.web_ag.backend_address_pool : pool.id if pool.name == local.backend_address_pool_name_app2])[0]
}
