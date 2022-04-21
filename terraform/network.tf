// Create virtual network

resource "azurerm_virtual_network" "vNet" {
  name                = "vNet-${var.project}"
  address_space       = [var.vNet-space[0]]
  location            = var.location
  resource_group_name = azurerm_resource_group.rgGroup.name

  tags = {
    "environment" = var.tag-environment[0]
  }

}

//Create subnet

resource "azurerm_subnet" "vNetSubnet" {
  name                 = "vNetSubnet-${var.project}"
  resource_group_name  = azurerm_resource_group.rgGroup.name
  virtual_network_name = azurerm_virtual_network.vNet.name
  address_prefixes     = var.vNet-subnet-space

}

//Create Pulic IP

resource "azurerm_public_ip" "public_ip" {
  name                = "publicIP-${var.project}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rgGroup.name
  allocation_method   = "Dynamic"


  tags = {
    "environment" = var.tag-environment[0]
  }
}

//resource "time_sleep" "wait_for_publicIP" {
// create_duration = "120s"
//depends_on = [azurerm_public_ip.public_ip]
//}