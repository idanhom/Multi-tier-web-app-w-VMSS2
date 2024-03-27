resource "azurerm_public_ip" "publicip_null_resource" {
  name                = "${local.resource_name_prefix}-null-publicip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

