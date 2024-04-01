resource "azurerm_subnet" "appsubnet" {
  name                 = "${local.rg_name}-appsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.app_subnet_address
}

resource "azurerm_network_security_group" "appsubnet_nsg" {
  name                = "${azurerm_subnet.appsubnet.name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_subnet_network_security_group_association" "appsubnet_nsg" {
  depends_on                = [azurerm_network_security_rule.app_nsg_rule_inbound]
  subnet_id                 = azurerm_subnet.appsubnet.id
  network_security_group_id = azurerm_network_security_group.appsubnet_nsg.id
}


resource "azurerm_network_security_rule" "app_nsg_rule_inbound" {
  for_each                    = local.app_inbound_ports_map
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.appsubnet_nsg.name
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# Mapping of inbound ports for application tier - maps external ports to internal application ports
locals {
  app_inbound_ports_map = {
    "100" : "80",   # HTTP
    "110" : "443",  # HTTPS
    "120" : "8080", # Alternative HTTP
    "130" : "22"    # SSH
  }
}



