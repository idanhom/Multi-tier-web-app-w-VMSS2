output "web-linuxvm-ip" {
  description = "ip address of web-linuxvm"
  value       = azurerm_network_interface.web_linuxvm_nic.private_ip_address
}

output "backend-linuxvm-ip" {
  description = "ip address of backend-linuxvm"
  value       = azurerm_network_interface.backend_linuxvm_nic.private_ip_address
}

//for troubleshooting to see that backend vm works as intended (it does)
# output "backend-linuxvm-pip" {
#   description = "pip of backend vm"
#   value = azurerm_public_ip.backend-pip.ip_address
# }




output "bastion-linuxvm-ip" {
  description = "ip address of bastion-linuxvm"
  value       = azurerm_public_ip.bastion_host_publicip.ip_address
}

output "ag-frontend-ip" {
  description = "ip address of ag-frontend"
  value       = azurerm_public_ip.ag_publicip.ip_address
}