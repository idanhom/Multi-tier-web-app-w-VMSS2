resource "azurerm_public_ip" "ag_publicip" {
  name                = "${local.resource_name_prefix}-ag-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

# Azure Application Gateway - Locals Block
locals {
  frontend_port_name             = "${local.resource_name_prefix}-feport"
  frontend_ip_configuration_name = "${local.resource_name_prefix}-feip"
  listener_name                  = "${local.resource_name_prefix}-httplstn"
  request_routing_rule_name      = "${local.resource_name_prefix}-rqrt"
  url_path_map_name              = "${local.resource_name_prefix}-upm"
  backend_address_pool_name      = "${local.resource_name_prefix}-beap"
  http_setting_name              = "${local.resource_name_prefix}-be-htst"
  probe_name                     = "${local.resource_name_prefix}-be-probe"
}

resource "azurerm_application_gateway" "ag" {
  name                = "${local.resource_name_prefix}-ag"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${local.resource_name_prefix}-gwip"
    subnet_id = azurerm_subnet.agsubnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ag_publicip.id
  }

  backend_address_pool {
    name         = "${local.resource_name_prefix}-web-vm-pool"
    ip_addresses = [azurerm_linux_virtual_machine.web_linuxvm.private_ip_address]
  }

  backend_address_pool {
    name         = "${local.resource_name_prefix}-backend-vm-pool"
    ip_addresses = [azurerm_linux_virtual_machine.backend_linuxvm.private_ip_address]
  }

  backend_http_settings {
    name                  = "${local.resource_name_prefix}-web-vm-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  backend_http_settings {
    name                  = "${local.resource_name_prefix}-backend-vm-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  # Health Probes for each VM
  probe {
    name                = "${local.resource_name_prefix}-web-vm-probe"
    protocol            = "Http"
    port                = 80
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = true
  }

  probe {
    name                = "${local.resource_name_prefix}-backend-vm-probe"
    protocol            = "Http"
    port                = 80
    path                = "/my_resume.pdf" # Path to check health for the Backend VM
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = true
  }

  url_path_map {
    name                               = local.url_path_map_name
    default_backend_address_pool_name  = "${local.resource_name_prefix}-web-vm-pool"
    default_backend_http_settings_name = "${local.resource_name_prefix}-web-vm-http-settings"

    path_rule {
      name                       = "resume-rule"
      paths                      = ["/content/*"]
      backend_address_pool_name  = "${local.resource_name_prefix}-backend-vm-pool"
      backend_http_settings_name = "${local.resource_name_prefix}-backend-vm-http-settings"
    }
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }



  request_routing_rule {
    name               = local.request_routing_rule_name
    priority = 100
    rule_type          = "PathBasedRouting"
    http_listener_name = local.listener_name
    url_path_map_name  = local.url_path_map_name
  }
}