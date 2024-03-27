# Assuming your VM and its associated Public IP are already defined

# Null Resource for File Transfer and Other Remote Operations
resource "null_resource" "copy_files_to_vm" {
  # Ensure this runs after the VM is created
  depends_on = [azurerm_linux_virtual_machine.web_linuxvm]

#   # Connection Block for SSH
#   connection {
#     type        = "ssh"
#     host        =  azurerm_public_ip.publicip_null_resource.ip_address  # Your VM's Public IP
#     user        = "azureuser"                                     # Your VM's admin username
#     private_key = file("${path.module}/.ssh/terraform-azure.pem") # Path to your private SSH key
#   }

  # File provisioner to transfer the CV to the VM
  provisioner "file" {
    source      = "${path.module}/content/Oscar_Pettersson.pdf"
    destination = "/var/www/html/Oscar_Pettersson.pdf"

    connection {
      type        = "ssh"
      user        = "azureuser"
      private_key = file("${path.module}/.ssh/terraform-azure.pem") # Ensure this is the path to your private key
      host        = azurerm_public_ip.publicip_null_resource.ip_address
    }
  }
}