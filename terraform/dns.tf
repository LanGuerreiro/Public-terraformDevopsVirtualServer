resource "azurerm_dns_a_record" "record_site" {
  name                = "${var.record_a_site}-${var.project}"
  zone_name           = var.dns_zone
  resource_group_name = var.rg_zone
  ttl                 = var.dns_TTL
  records             = [azurerm_linux_virtual_machine.linuxVM.public_ip_address]
  depends_on = [azurerm_linux_virtual_machine.linuxVM]

}

