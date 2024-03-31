#here is need the config for hosting the resumé.
#how to do with public ip or lb?resource "azurerm_network_interface" "resume_vm_nic" {
locals {
  resume_vm_custom_data = <<EOF
#!/bin/bash
# Install Apache
sudo yum install -y httpd
# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd
# Disable the firewall
sudo systemctl stop firewalld
sudo systemctl disable firewalld
# Create a placeholder HTML page for the resume
echo '<!DOCTYPE html><html><head><title>Resume</title></head><body><h1>Resume will be available shortly.</h1></body></html>' | sudo tee /var/www/html/index.html
# Restart Apache to apply changes
sudo systemctl restart httpd
EOF
}



resource "azurerm_network_interface" "app_linuxvm_nic" {
  name                = "${local.resource_name_prefix}-resume-vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "resume-vm-ip-config"
    subnet_id                     = azurerm_subnet.appsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "app_linuxvm" {
  name                  = "${local.resource_name_prefix}-resume-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.app_linuxvm_nic.id ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/.ssh/terraform-azure.pub")
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

  custom_data = base64encode(local.resume_vm_custom_data)
}

