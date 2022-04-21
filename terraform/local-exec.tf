resource "null_resource" "createHostFile" {
  provisioner "local-exec" {
    command = "cat ../output/publicIP-${var.project}.txt > ../output/inventory; echo -e '\n[all:vars] \nansible_ssh_user=${var.adminUser} \nansible_ssh_private_key_file=../pem/vm-${var.project}.pem'>> ../output/inventory"
  }
  depends_on = [
    local_file.outputip
  ]
}

resource "null_resource" "chmodPem" {
  provisioner "local-exec" {
    command = "chmod 600 ../pem/vm-${var.project}.pem"
  }
  depends_on = [
    local_file.cloud_pem
  ]
}

resource "null_resource" "runAnsible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../output/inventory ../ansible/playbook-webserver.yml"
  }
  depends_on = [
    local_file.outputip
      ]
}

