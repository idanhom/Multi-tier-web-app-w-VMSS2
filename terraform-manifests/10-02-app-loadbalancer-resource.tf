# # Public IP for App Load Balancer
# resource "azurerm_public_ip" "app_publicip" {
#   name                = "${local.resource_name_prefix}-app-lb-public-ip"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# # App Load Balancer
# resource "azurerm_lb" "app_lb" {
#   name                = "${local.resource_name_prefix}-app-lb"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   sku                 = "Standard"
#   frontend_ip_configuration {
#     name                 = "app-lb-publicip-1"
#     public_ip_address_id = azurerm_public_ip.app_publicip.id
#   }
# }

# # Backend Address Pool for App VM
# resource "azurerm_lb_backend_address_pool" "app_lb_backend_address_pool" {
#   name            = "app-backend"
#   loadbalancer_id = azurerm_lb.app_lb.id
# }

# # Health Probe for App Load Balancer
# resource "azurerm_lb_probe" "app_lb_probe" {
#   name            = "app-tcp-probe"
#   protocol        = "Tcp"
#   port            = 80
#   loadbalancer_id = azurerm_lb.app_lb.id
# }

# # Load Balancing Rule for App VM
# resource "azurerm_lb_rule" "app_lb_rule" {
#   name                           = "app-rule"
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   frontend_ip_configuration_name = azurerm_lb.app_lb.frontend_ip_configuration[0].name
#   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.app_lb_backend_address_pool.id]
#   probe_id                       = azurerm_lb_probe.app_lb_probe.id
#   loadbalancer_id                = azurerm_lb.app_lb.id

# }

# # Associate App VM NIC with the Backend Address Pool
# resource "azurerm_network_interface_backend_address_pool_association" "app_nic_lb_associate" {
#   network_interface_id    = azurerm_network_interface.app_linuxvm_nic.id
#   ip_configuration_name   = azurerm_network_interface.app_linuxvm_nic.ip_configuration[0].name
#   backend_address_pool_id = azurerm_lb_backend_address_pool.app_lb_backend_address_pool.id
# }
