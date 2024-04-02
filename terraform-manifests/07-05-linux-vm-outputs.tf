output "web-linuxvm-ip" {
  description = "ip address of web-linuxvm"
  value = azurerm_network_interface.web_linuxvm_nic.private_ip_address
}

output "backend-linuxvm-ip" {
  description = "ip address of backend-linuxvm"
  value = azurerm_network_interface.backend_linuxvm_nic.private_ip_address
}

output "bastion-linuxvm-ip" {
  description = "ip address of bastion-linuxvm"
  value = azurerm_network_interface.bastion_host_linuxvm_nic.private_ip_address
}