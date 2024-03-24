resource "azurerm_public_ip" "publicip" {
  name                = "${var.business_unit}-publicip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

