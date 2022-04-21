// Create a resource group

resource "azurerm_resource_group" "rgGroup" {
  name     = "rgGroup-${var.project}"
  location = var.location

  tags = {
    "environment" = var.tag-environment[0]
  }

}

// Connect the security group to the network interface

resource "azurerm_network_interface_security_group_association" "associationNSG" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsgGroup.id
}

// Create an SSH Key

resource "tls_private_key" "privateSSH" {
  algorithm = "RSA"
  rsa_bits  = 4096

}
//Save pem
resource "local_file" "cloud_pem" {
  filename = "../pem/vm-${var.project}.pem"
  content  = tls_private_key.privateSSH.private_key_pem
}

//Create Virtual Machine

resource "azurerm_linux_virtual_machine" "linuxVM" {
  name                  = "vm-${var.project}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rgGroup.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8.2"
    version   = "latest"
  }

  os_disk {
    name                 = "osDisk-${var.project}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name                   = "vm-${var.project}"
  admin_username                  = var.adminUser
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.adminUser
    public_key = tls_private_key.privateSSH.public_key_openssh
  }

  tags = {
    "environment" = var.tag-environment[0]
  }


}


