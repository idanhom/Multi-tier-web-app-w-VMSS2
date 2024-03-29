# Null Resource for File Transfer and Other Remote Operations
resource "null_resource" "copy_files_to_vm" {
  # Ensure this runs after the VM is created
  depends_on = [azurerm_linux_virtual_machine.web_linuxvm]

  connection {
    type        = "ssh"
    user        = "azureuser"
    private_key = file("${path.module}/.ssh/terraform-azure.pem") # Ensure this is the path to your private key
    host        = azurerm_public_ip.jumpbox_public_ip.ip_address
  }


    provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /var/www/html",
      "sudo chown ${azurerm_linux_virtual_machine.web_linuxvm.admin_username} /var/www/html"
    ]
  }

  # File provisioner to transfer the CV to the VM
  provisioner "file" {
    source      = "${path.module}/content/Oscar_Pettersson.pdf"
    destination = "/var/www/html/Oscar_Pettersson.pdf"


  }
}