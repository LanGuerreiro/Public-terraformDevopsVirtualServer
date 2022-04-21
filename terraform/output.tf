// Output Private key sensitive
#output "tls_private_key" {
#  value     = tls_private_key.privateSSH.private_key_pem
#  sensitive = true
#}

// Output Ip Public
output "azurerm_public_ip" {
  //value = azurerm_public_ip.public_ip.ip_address
  value      = azurerm_linux_virtual_machine.linuxVM.public_ip_address
  depends_on = [azurerm_linux_virtual_machine.linuxVM]
}
//Save outputIP
resource "local_file" "outputip" {
  depends_on = [
    azurerm_linux_virtual_machine.linuxVM
  ]

  content  = azurerm_linux_virtual_machine.linuxVM.public_ip_address
  filename = "../output/publicIP-${var.project}.txt"

}