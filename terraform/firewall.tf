resource "linode_firewall_device" "site-firewall-vms" {
  count       = length(var.app_servers)
  firewall_id = linode_firewall.site-firewall.id
  entity_id   = element(linode_instance.site-vm.*.id, count.index)
}

resource "linode_firewall" "site-firewall" {
  label = "site-firewall"
  tags = [
    "${var.site}-firewall"
  ]

  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    label    = "inbound-http"
    protocol = "TCP"
    action   = "ACCEPT"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
  }

  outbound {
    label    = "outbound-http"
    protocol = "TCP"
    action   = "ACCEPT"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound {
    label    = "inbound-https"
    protocol = "TCP"
    action   = "ACCEPT"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
  }

  outbound {
    label    = "outbound-https"
    protocol = "TCP"
    action   = "ACCEPT"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound {
    label    = "inbound-ssh-22"
    protocol = "TCP"
    action   = "ACCEPT"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound {
    label    = "inbound-ssh-8822"
    protocol = "TCP"
    action   = "ACCEPT"
    ports    = "8822"
    ipv4     = ["0.0.0.0/0"]
  }
}
