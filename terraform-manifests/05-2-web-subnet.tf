resource "azurerm_subnet" "mysubnet" {
  name                 = "${var.business_unit}-${var.virtual_network_name}-mysubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "web_subnet_nsg" {
  name                = "${azurerm_subnet.websubnet.name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg" {
  depends_on                = [azurerm_network_security_rule.web_nsg_rule_inbound]
  subnet_id                 = azurerm_subnet.mysubnet.id
  network_security_group_id = azurerm_network_security_group.web_subnet_nsg.id
}


resource "azurerm_network_security_rule" "web_nsg_rule_inbound" {
  for_each                    = local.web_inbound_ports_map
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
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