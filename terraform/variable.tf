variable "location" {
  default = "westus2"
  type    = string
}
variable "project" {
  default = "tf-ans"
  type    = string
}
variable "vm_size" {
  default = "Standard_B1s"
  type    = string
}

variable "tag-environment" {
  type = list(string)
  default = [
    "Terraform lab"
  ]

}
variable "vNet-space" {
  type = list(string)
  default = [
    "10.20.0.0/24"
  ]

}
variable "vNet-subnet-space" {
  type = list(string)
  default = [
    "10.20.0.0/28"
  ]

}
variable "adminUser" {
  type    = string
  default = "admaz"

}
variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
  sensitive = true

}
variable "client_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
  sensitive = true

}
variable "client_secret" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
  sensitive = true

}
variable "tenant_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
  sensitive = true

}
variable "dns_zone" {
  default = "exemple.com.br"
}
variable "rg_zone" {
  default = "rg-dns"
}
variable "dns_TTL" {
   default = "60"
}
variable "record_a_site" {
  default = "www"
}