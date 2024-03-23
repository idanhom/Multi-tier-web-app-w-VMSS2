locals {
  webvm_custom_data = <<CUSTOM_DATA
#!/bin/bash
# Update system packages
sudo yum update -y

# Install Apache web server
sudo yum install -y httpd

# Enable and start the Apache service
sudo systemctl enable httpd
sudo systemctl start httpd

# Create an index.html file
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Oscars Resume</title>
</head>
<body>
    <h1>Hej Emil!</h1>
    <object data="Oscar_Pettersson.pdf" type="application/pdf" width="100%" height="100%">
        <p>Your browser does not support PDFs.
        <a href="Oscar_Pettersson.pdf">Download the PDF</a>.</p>
    </object>
</body>
</html>
EOF

# Restart Apache to apply changes
sudo systemctl restart httpd
CUSTOM_DATA
}




# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "web_linuxvm" {
  name = "${local.resource_name_prefix}-web-linuxvm"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location 
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  network_interface_ids = [ azurerm_network_interface.web_linuxvm_nic.id ]
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/.ssh/terraform-azure.pub")
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }  
  source_image_reference {
    publisher = "RedHat"
    offer = "RHEL"
    sku = "83-gen2"
    version = "latest"
  }  

  custom_data = base64encode(local.webvm_custom_data)
}