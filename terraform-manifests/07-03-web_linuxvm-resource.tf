locals {
  webvm_custom_data = <<CUSTOM_DATA
#!/bin/sh
# Install Apache web server
sudo yum install -y httpd

# Enable and start the Apache service
sudo systemctl enable httpd
sudo systemctl start httpd

# Stop and disable the firewall to ensure web server accessibility
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Set permissive permissions on the web root to avoid permission issues
sudo chmod -R 777 /var/www/html

# Create an index.html file with a message and a link to the resume
cat <<EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Oscars Resume</title>
</head>
<body>
    <h1>Hej Emil!</h1>
    <p>Klicka nedan för att ladda ner CV</p>
    <a href="Oscar_Pettersson.pdf">Ladda ner CV</a>
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

      # File provisioner to transfer the CV to the VM
  provisioner "file" {
    source      = "${path.module}/content/Oscar_Pettersson.pdf"
    destination = "/var/www/html/Oscar_Pettersson.pdf"

    connection {
      type        = "ssh"
      user        = "azureuser"
      private_key = file("${path.module}/.ssh/terraform-azure.pem") # Ensure this is the path to your private key
      host        = azurerm_linux_virtual_machine.web_linuxvm.public_ip_address
    }
  }
}