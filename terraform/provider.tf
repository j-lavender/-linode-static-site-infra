terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.25.2"
    }
  }
}

provider "linode" {
  token = var.token
}

resource "linode_sshkey" "main_key" {
  label = "ssh_key"
  ssh_key = chomp(file(var.ssh_key))
}