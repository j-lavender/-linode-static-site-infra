resource "linode_nodebalancer" "site-nodebalancer" {
  label  = "site-nodebalancer"
  region = var.region
  tags = [
    "${var.site}-nodebalancer"
  ]
}

resource "linode_nodebalancer_config" "site-nodebalancer-config-http" {
  nodebalancer_id = linode_nodebalancer.site-nodebalancer.id
  port            = 80
  protocol        = "tcp"
  check           = "connection"
  check_path      = "/"
  check_attempts  = 3
  check_timeout   = 25
  check_interval  = 30
  stickiness      = "none"
  algorithm       = "leastconn"
}

resource "linode_nodebalancer_config" "site-nodebalancer-config-https" {
  nodebalancer_id = linode_nodebalancer.site-nodebalancer.id
  port            = 443
  protocol        = "tcp"
  check           = "connection"
  check_path      = "/"
  check_attempts  = 3
  check_timeout   = 25
  check_interval  = 30
  stickiness      = "none"
  algorithm       = "leastconn"
}

resource "linode_nodebalancer_node" "site-nodebalancer-nodes-http" {
  count           = length(var.app_servers)
  nodebalancer_id = linode_nodebalancer.site-nodebalancer.id
  config_id       = linode_nodebalancer_config.site-nodebalancer-config-http.id
  label           = "app${count.index}"
  address         = "${element(linode_instance.site-vm.*.private_ip_address, count.index)}:80"
  mode            = "accept"
}

resource "linode_nodebalancer_node" "site-nodebalancer-nodes-https" {
  count           = length(var.app_servers)
  nodebalancer_id = linode_nodebalancer.site-nodebalancer.id
  config_id       = linode_nodebalancer_config.site-nodebalancer-config-https.id
  label           = "app${count.index}"
  address         = "${element(linode_instance.site-vm.*.private_ip_address, count.index)}:443"
  mode            = "accept"
}

output "nodebalancer_ip_address" {
  value = linode_nodebalancer.site-nodebalancer.ipv4
}