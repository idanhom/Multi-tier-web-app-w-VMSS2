resource "azurerm_subnet" "appsubnet" {
  name                 = "${var.business_unit}-${var.virtual_network_name}-appsubnet"
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









# location            = azurerm_resource_group.rg.location
# resource_group_name = azurerm_resource_group.rg.name

# dynamic "security_rule" {
#   for_each = local.web_inbound_ports_map
#   content {
#     name                       = security_rule.key
#     priority                   = security_rule.value.priority
#     direction                  = security_rule.value.direction
#     access                     = security_rule.value.access
#     protocol                   = security_rule.value.protocol
#     source_port_range          = security_rule.value.source_port_range
#     destination_port_range     = security_rule.value.destination_port_range
#     source_address_prefix      = security_rule.value.source_address_prefix
#     destination_address_prefix = security_rule.value.destination_address_prefix
#   }
# }