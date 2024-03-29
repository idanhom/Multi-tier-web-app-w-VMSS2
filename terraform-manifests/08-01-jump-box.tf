resource "azurerm_public_ip" "jumpbox_public_ip" {
  name                = "${local.resource_name_prefix}-null-publicip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "${local.resource_name_prefix}-jumpbox-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "jumpbox-ip-config"
    subnet_id                     = azurerm_subnet.websubnet.id  # Assuming it's the same subnet; adjust if needed
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_public_ip.id
  }
}


resource "azurerm_linux_virtual_machine" "jumpbox_vm" {
  name                  = "${local.resource_name_prefix}-jumpbox-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1s"  # Choose an appropriate size
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.jumpbox_nic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/.ssh/terraform-azure.pub")  # Adjust the path to your public key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
}