resource "linode_instance" "site-vm" {
    count = length(var.app_servers)
    label = "${var.site}-app${count.index}"
    tags = [
      "${var.site}-app${count.index}"
    ]
    region = var.region
    private_ip = true
    type = var.app_servers[count.index].type
    image = var.app_servers[count.index].image
    authorized_keys = [
      linode_sshkey.main_key.ssh_key
    ]
}

output "linode_instance_ip_address" {
    value = linode_instance.site-vm.*.ipv4
}