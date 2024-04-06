resource "azurerm_public_ip" "ag_publicip" {
  name                = "${local.resource_name_prefix}-ag-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Azure Application Gateway - Locals Block
locals {
  frontend_port_name             = "${local.resource_name_prefix}-feport"
  frontend_ip_configuration_name = "${local.resource_name_prefix}-feip"
  listener_name                  = "${local.resource_name_prefix}-httplstn"
  request_routing_rule_name      = "${local.resource_name_prefix}-rqrt"
  url_path_map_name              = "${local.resource_name_prefix}-upm"

  // Backend pools names specific to each VM, adapt to my setup 
  backend_address_pool_name_web    = "${local.resource_name_prefix}-web-vm-pool"
  backend_address_pool_name_backend = "${local.resource_name_prefix}-backend-vm-pool"

  // HTTP settings names specific to each VM
  http_setting_name_web    = "${local.resource_name_prefix}-web-vm-http-settings"
  http_setting_name_backend = "${local.resource_name_prefix}-backend-vm-http-settings"

  // Health probe names specific to each VM
  probe_name_web    = "${local.resource_name_prefix}-web-vm-probe"
  probe_name_backend = "${local.resource_name_prefix}-backend-vm-probe"


  # IS THIS SOMETHING TO ADD TO THE CONFIG?
  # Default Redirect on Root Context (/)
  redirect_configuration_name    = "${azurerm_virtual_network.vnet.name}-rdrcfg"
  
  
  # old settings
  # backend_address_pool_name      = "${local.resource_name_prefix}-beap"
  # http_setting_name              = "${local.resource_name_prefix}-be-htst"
  # probe_name                     = "${local.resource_name_prefix}-be-probe"
}

resource "azurerm_application_gateway" "ag" {
  name                = "${local.resource_name_prefix}-ag"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${local.resource_name_prefix}-gwip"
    subnet_id = azurerm_subnet.agsubnet.id
  }

  # Front End Config
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  # Listener: HTTP Port 80
  http_listener {
  name                           = local.listener_name
  frontend_ip_configuration_name = local.frontend_ip_configuration_name
  frontend_port_name             = local.frontend_port_name
  protocol                       = "Http"
}

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ag_publicip.id
  }

  # Web Linux VM
  backend_address_pool {
    name         = local.backend_address_pool_name_web
    ip_addresses = [azurerm_linux_virtual_machine.web_linuxvm.private_ip_address]
  }
    backend_http_settings {
    name                  = local.http_setting_name_web
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }
    probe {
    name                                      = local.probe_name_web
    protocol                                  = "Http"
    port                                      = 80
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }



  # Backend Linux VM
  backend_address_pool {
    name         = local.backend_address_pool_name_backend
    ip_addresses = [azurerm_linux_virtual_machine.backend_linuxvm.private_ip_address]
  }
    backend_http_settings {
    name                  = local.http_setting_name_backend
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }
    probe {
    name                                      = local.probe_name_backend
    protocol                                  = "Http"
    port                                      = 80
    path                                      = "/health.html"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    host = "10.0.2.4"
    #pick_host_name_from_backend_http_settings = true
  }




  url_path_map {
    name                               = local.url_path_map_name
    default_backend_address_pool_name  = local.backend_address_pool_name_web
    default_backend_http_settings_name = local.http_setting_name_web

    path_rule {
      name                       = "backend-rule"
      paths                      = ["/content/*"]
      backend_address_pool_name  = local.backend_address_pool_name_backend
      backend_http_settings_name = local.http_setting_name_backend
    }
  }



  request_routing_rule {
    name               = local.request_routing_rule_name
    priority           = 100
    rule_type          = "PathBasedRouting"
    http_listener_name = local.listener_name
    url_path_map_name  = local.url_path_map_name
  }
}