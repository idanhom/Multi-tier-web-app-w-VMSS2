locals {
  probe_path_web         = "/"
  probe_path_backend     = "/health.html"
  http_port              = 80
  https_port             = 443
  http_protocol          = "Http"
  https_protocol         = "Https"
  http_timeout           = 60
  https_timeout          = 60
  probe_interval         = 30
  probe_timeout          = 30
  probe_unhealthy_thresh = 3
  ssl_certificate_name   = "ssl-cert" 
}

resource "azurerm_public_ip" "ag_publicip" {
  name                = "${local.resource_name_prefix}-ag-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
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

  # Frontend Configuration
  frontend_port {
    name = "${local.resource_name_prefix}-feport"
    port = local.http_port
  }

  # Added HTTPS frontend port
  frontend_port {
    name = "${local.resource_name_prefix}-httpslstn"
    port = local.https_port
  }
    
  frontend_ip_configuration {
    name                 = "${local.resource_name_prefix}-feip"
    public_ip_address_id = azurerm_public_ip.ag_publicip.id
  }


  ssl_certificate {
    name     = local.ssl_certificate_name
    data     = filebase64("${path.module}/ssl-self-signed/httpd.pfx")
    password = "oscar"
  }


  # Listener: HTTP Port 80
  http_listener {
    name                           = "${local.resource_name_prefix}-httplstn"
    frontend_ip_configuration_name = "${local.resource_name_prefix}-feip"
    frontend_port_name             = "${local.resource_name_prefix}-feport"
    protocol                       = local.http_protocol
  }

  # Listener: HTTP Port 443
  http_listener {
    name                           = "${local.resource_name_prefix}-httpslstn"
    frontend_ip_configuration_name = "${local.resource_name_prefix}-feip"
    frontend_port_name             = "${local.resource_name_prefix}-httpslstn"
    protocol                       = local.https_protocol
    ssl_certificate_name           = local.ssl_certificate_name


    #Not modified to my config
    custom_error_configuration {
      custom_error_page_url = "${azurerm_storage_account.storage_account.primary_web_endpoint}502.html"
      status_code           = "HttpStatus502"
    }
    custom_error_configuration {
      custom_error_page_url = "${azurerm_storage_account.storage_account.primary_web_endpoint}403.html"
      status_code           = "HttpStatus403"
    }    


  }



  # Backend HTTP Settings for Static Web VM
  backend_http_settings {
    name                  = "${local.resource_name_prefix}-web-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = local.http_port
    protocol              = local.http_protocol
    request_timeout       = local.http_timeout
  }

  # Backend HTTP Settings for Backend VM
  backend_http_settings {
    name                  = "${local.resource_name_prefix}-backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = local.http_port
    protocol              = local.http_protocol
    request_timeout       = local.http_timeout
    probe_name            = "${local.resource_name_prefix}-backend-probe"
  }

  probe {
    name                                      = "${local.resource_name_prefix}-web-probe"
    protocol                                  = local.http_protocol
    port                                      = local.http_port
    path                                      = local.probe_path_web
    interval                                  = local.probe_interval
    timeout                                   = local.probe_timeout
    unhealthy_threshold                       = local.probe_unhealthy_thresh
    pick_host_name_from_backend_http_settings = true
  }

  probe {
    name                = "${local.resource_name_prefix}-backend-probe"
    protocol            = local.http_protocol
    port                = local.http_port
    path                = local.probe_path_backend
    interval            = local.probe_interval
    timeout             = local.probe_timeout
    unhealthy_threshold = local.probe_unhealthy_thresh
    host                = azurerm_network_interface.backend_linuxvm_nic.private_ip_address
  }

  # Backend Address Pools
  backend_address_pool {
    name         = "${local.resource_name_prefix}-web-pool"
    ip_addresses = [azurerm_network_interface.web_linuxvm_nic.private_ip_address]
  }

  backend_address_pool {
    name         = "${local.resource_name_prefix}-backend-pool"
    ip_addresses = [azurerm_network_interface.backend_linuxvm_nic.private_ip_address]
  }





  # Redirect Configuration for HTTP to HTTPS
  redirect_configuration {
    name                 = "${local.resource_name_prefix}-http-to-https"
    redirect_type        = "Permanent"
    target_listener_name = "${local.resource_name_prefix}-httpslstn"
    include_path         = true
    include_query_string = true
  }


  # Modify the existing HTTP Routing Rule for redirection
  request_routing_rule {
    name                        = "${local.resource_name_prefix}-http-to-https-rule"
    rule_type                   = "Basic"
    priority                    = 100
    http_listener_name          = "${local.resource_name_prefix}-httplstn"
    redirect_configuration_name = "${local.resource_name_prefix}-http-to-https"
  }


  # URL Path Map for Routing
  url_path_map {
    name                               = "${local.resource_name_prefix}-upm"
    default_backend_address_pool_name  = "${local.resource_name_prefix}-web-pool"
    default_backend_http_settings_name = "${local.resource_name_prefix}-web-http-settings"

    path_rule {
      name                       = "backend-rule"
      paths                      = ["/content/*"]
      backend_address_pool_name  = "${local.resource_name_prefix}-backend-pool"
      backend_http_settings_name = "${local.resource_name_prefix}-backend-http-settings"
    }
  }

  # Request Routing Rule
  request_routing_rule {
    name               = "${local.resource_name_prefix}-https-path-based-rule"
    rule_type          = "PathBasedRouting"
    priority           = 110
    http_listener_name = "${local.resource_name_prefix}-httpslstn"
    url_path_map_name  = "${local.resource_name_prefix}-upm"
  }



}
