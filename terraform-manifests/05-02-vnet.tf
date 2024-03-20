resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


# # these things should be placed at another place, and changed accordingly
# resource "azurerm_public_ip" "mypublicip" {
#   name                = "${var.business_unit}-${var.virtual_network_name}-mypublicip"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   allocation_method   = "Static"
# }

# resource "azurerm_network_interface" "myvmnic" {
#   name                = "${var.business_unit}-${var.virtual_network_name}-myvmnic"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.mysubnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.mypublicip.id
#   }
# }


