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
    local_file.outputip,local_file.createAnsibleFile
      ]
}


resource "null_resource" "createVirtualHost" {
  provisioner "local-exec" {
    command = "echo -e '\n<VirtualHost *:80>\n    ServerAdmin webmaster@localhost\n    DocumentRoot /var/www/html/${azurerm_dns_a_record.record_site.name}.${var.dns_zone}\n    ServerName ${azurerm_dns_a_record.record_site.name}.${var.dns_zone}\n    <Directory /var/www/html/${azurerm_dns_a_record.record_site.name}.${var.dns_zone}>\n        AllowOverride All\n    </Directory>\n</VirtualHost>'>> ../virtualHost/template.txt"
  }
  depends_on = [
    azurerm_dns_a_record.record_site
  ]
}



resource "local_file" "createAnsibleFile" {
  content = <<-DOC
---
 - name: Setup web Server
   hosts: all
   become: true
   vars:
     http_host: "${azurerm_dns_a_record.record_site.name}.${var.dns_zone}"
     http_conf: "${azurerm_dns_a_record.record_site.name}.${var.dns_zone}.conf"
     disable_default: true
     
   tasks:
   - name: all update
     yum:
       name: '*'
       state: latest

   - name: Install the latest version of apache
     yum:
       name: httpd
       state: latest

   - name: Start service httpd and enabled
     service:
       name: httpd
       state: started
       enabled: true

   - name: Open firewall port 80
     firewalld:
      service: http
      permanent: true
      state: enabled
      zone: public
   
   - name: reload service firewalld
     systemd:
      name: firewalld
      state: reloaded
  
   - name: Copy WEB PAGE to remote server
     copy:
      src: ../pageHtml/
      dest: "/var/www/html/{{ http_host }}"

   - name: Copy HTTPD CONF to remote server
     copy:
      src: ../virtualHost/template.txt
      dest: "/etc/httpd/conf.d/{{ http_conf }}"
  
   - name: Remove file HTTPD default conf
     file: 
       path: "{{ item }}"
       state: absent
     with_items:
       - /etc/httpd/conf.d/welcome.conf
       - /etc/httpd/conf.d/userdir.conf
       - /etc/httpd/conf.d/autoindex.conf
       - /etc/httpd/conf.d/README

   - name: Reload HTTPD
     service:
       name: httpd
       state: reloaded
       enabled: true

    DOC


  filename = "../ansible/playbook-webserver.yml"

  depends_on = [
    azurerm_dns_a_record.record_site
  ]
}