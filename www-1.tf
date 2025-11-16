resource "digitalocean_droplet" "www-1" {
    image = "ubuntu-24-04-x64"
    name = "www-1"
    region = "tor1"
    size = "s-1vcpu-1gb"
    vpc_uuid = digitalocean_vpc.main.id

    ssh_keys = [
        data.digitalocean_ssh_key.terraform.id
    ]

    tags = ["production", "web", "terraform"]

    user_data = <<EOF
#cloud-config
package_update: true
package_upgrade: true
packages:
  - nginx

users:
  - name: webadmin
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${file("~/.ssh/lenovo-max.pub")}

runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
  - systemctl restart sshd
EOF
}