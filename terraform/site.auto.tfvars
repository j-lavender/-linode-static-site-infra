site = "example.com"
region = "us-southeast"
environment = "production"
app_servers = [
    {
        type = "g6-nanode-1"
        image = "linode/ubuntu20.04"
    },
    {
        type = "g6-nanode-1"
        image = "linode/ubuntu20.04"
    }
]
bastion_server = {
    type = "g6-nanode-1"
    image = "linode/ubuntu20.04"
}
ssh_key = "~/.ssh/id_rsa.pub"