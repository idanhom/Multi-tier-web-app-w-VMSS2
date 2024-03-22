# Locals Block for custom data
locals {
  webvm_custom_data = <<CUSTOM_DATA
#!/bin/sh
# Update system packages
sudo yum update -y

# Install Apache web server
sudo yum install -y httpd

# Enable and start the Apache service
sudo systemctl enable httpd
sudo systemctl start httpd

# Disable and stop the firewalld (Consider configuring it properly for production)
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Set proper permissions (Consider more restrictive permissions for production)
sudo chown apache:apache /var/www/html
sudo chmod -R 755 /var/www/html

# Create an index.html file for your resume
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Emil's Resume</title>
</head>
<body>
    <h1>Hej Emil!</h1>
    <p>Welcome to my online resume.</p>
    <h2>About Me</h2>
    <p>[Your About Me content]</p>
    <h2>Experience</h2>
    <p>[Your Experience content]</p>
    <h2>Contact</h2>
    <p>Email: [Your email]</p>
    <p>Phone: [Your phone number]</p>
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
  #computer_name = "web-linux-vm" # Hostname of the VM (Optional)
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location 
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  network_interface_ids = [ azurerm_network_interface.web_linuxvm_nic.id ]
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
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
  #custom_data = filebase64("${path.module}/app-scripts/redhat-webvm-script.sh")
  custom_data = base64encode(local.webvm_custom_data)
}