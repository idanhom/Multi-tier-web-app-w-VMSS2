locals {
  resume_vm_custom_data = <<CUSTOM_DATA
#!/bin/bash
# Install Apache and curl
sudo yum install -y httpd curl

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Disable the firewall
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Create the content directory
sudo mkdir -p /var/www/html/content

# Download the resume PDF into the content directory
sudo curl -o /var/www/html/content/my_resume.pdf https://resumeoscar.blob.core.windows.net/resume/resume/Oscar_Pettersson.pdf

# Create an HTML page within the content directory to link to the PDF resume
echo '<!DOCTYPE html><html><head><title>My Resume</title></head><body><h1>My Resume</h1><p>View my <a href="/content/my_resume.pdf">resume</a>.</p></body></html>' | sudo tee /var/www/html/content/index.html

# Set permissions and ownership for Apache to access the content
sudo chown -R apache:apache /var/www/html/content
sudo chmod -R 755 /var/www/html/content

#^added new permissions see if that solves the problem

# Restart Apache to apply changes
sudo systemctl restart httpd
CUSTOM_DATA
}


//for trobuleshooting to ensure vm works as intended.
# resource "azurerm_public_ip" "backend-pip" {
#   name = "backend-public-ip"
#   resource_group_name = azurerm_resource_group.rg.name
#   location = azurerm_resource_group.rg.location
#   allocation_method = "Static"
# }


resource "azurerm_network_interface" "backend_linuxvm_nic" {
  name                = "${local.resource_name_prefix}-resume-vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "resume-vm-ip-config"
    subnet_id                     = azurerm_subnet.backendsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.backend-pip.id
  }
}

resource "azurerm_linux_virtual_machine" "backend_linuxvm" {
  name                  = "${local.resource_name_prefix}-resume-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.backend_linuxvm_nic.id]

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

