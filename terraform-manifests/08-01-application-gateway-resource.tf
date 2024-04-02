# Resource-1: Azure Application Gateway Public IP
resource "azurerm_public_ip" "web_ag_publicip" {
  name                = "${local.resource_name_prefix}-web-ag-publicip"
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
  backend_address_pool_name      = "${local.resource_name_prefix}-beap"
  http_setting_name              = "${local.resource_name_prefix}-be-htst"
  probe_name                     = "${local.resource_name_prefix}-be-probe"
}

# Resource-2: Azure Application Gateway - Standard_v2
resource "azurerm_application_gateway" "web_ag" {
  name                = "${local.resource_name_prefix}-web-ag"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
  }
  autoscale_configuration {
    min_capacity = 2
    max_capacity = 10
  }  

  gateway_ip_configuration {
    name      = "${local.resource_name_prefix}-gateway-ip-configuration"
    subnet_id = azurerm_subnet.agsubnet.id
  }

  # Front End Configs
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.web_ag_publicip.id    
  }

  # Listener: HTTP Port 80
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  # Backend Configs
  backend_address_pool {
    name = local.backend_address_pool_name
    # Add your VMSS or specific VM backend IP configurations here
  }
  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }
  probe {
    name                = local.probe_name
    protocol            = "Http"
    port                = 80
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }   

  # URL Path Map for Routing Rules
  url_path_map {
    name                           = local.url_path_map_name
    default_backend_address_pool_name = local.backend_address_pool_name
    default_backend_http_settings_name = local.http_setting_name

    # Path rule for resume content
    path_rule {
      name                        = "content-rule"
      paths                       = ["/content/*"]
      backend_address_pool_name   = local.backend_address_pool_name
      backend_http_settings_name  = local.http_setting_name
    }
  }

  # Routing Rule using URL Path Map
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "PathBasedRouting"
    http_listener_name         = local.listener_name
    url_path_map_name          = local.url_path_map_name
  }
}
