# Null Resource for File Transfer and Other Remote Operations
resource "null_resource" "copy_ssh_to_vm" {
  # Ensure this runs after the VM is created
  depends_on = [azurerm_linux_virtual_machine.bastion_host_linuxvm]

  connection {
    type        = "ssh"
    user        = "azureuser"
    private_key = file("${path.module}/.ssh/terraform-azure.pem")
    host        = azurerm_network_interface.web_linuxvm_nic.private_ip_address
  }

  provisioner "file" {
    source      = "${path.module}/.ssh/terraform-azure.pem"
    destination = "/tmp/terraform-azure.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-azure.pem"
  ]
  }
}