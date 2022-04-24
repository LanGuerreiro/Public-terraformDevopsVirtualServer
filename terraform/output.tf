
// Output Ip Public
output "azurerm_public_ip" {
  
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

output "dns_name" {
  value = azurerm_dns_a_record.record_site.fqdn
  depends_on = [
    azurerm_dns_a_record.record_site

  ]
  
}



