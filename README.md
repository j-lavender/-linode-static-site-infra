Linode Static Site Infrastructure
===============

This repo provides the Terraform and Ansible configuration for generating and hosting static-sites using [Linode](https://linode.com).

The infrastructure inside Linode will consist of two application instances served behind a NodeBalancer. These instances will have external IPs used to configure and deploy to them. Linode Firewalls in combination with UFW are used to limit access to them. 

On the instances themselves, an administrative user and deploy user are created (as well as a user for Caddy). Caddy is used as the web-server in order to accommodate automatic-HTTPS of each site. 

The jekyll site provided in this repo is an example and includes the necessary Capistrano configuration to perform deploys.

_Hint: If configured properly using the provided setup, a different set of static sites can be served to multiple domains from the same set of app instances._

## Using the repo

### Initialize Linode Infrastructure - Terraform

First, clone the repo. Then `cd terraform/`. From here, use the following commands to connect Terraform to the Linode account:

        echo "export TF_VAR_token=<<linode_account_api_token>>" >> .envrc
        direnv allow
        terraform init

Once Terraform has been initialized, set the appropriate variables for the desired infrastructure in `site.auto.tfvars`:

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

After filling in the variables, use `terraform plan` to ensure the proper infrastructure will be generated. `terraform apply` will generate the infrastructure.

Upon completion, `terraform apply` will supply the IPv4 addresses of the NodeBalancer, as well as the site instances:

        Outputs:

        linode_instance_ip_address = [
        toset([
        "192.168.232.187",
        "45.79.216.88",
        ]),
        toset([
        "192.168.144.144",
        "45.79.216.70",
        ]),
        ]
        nodebalancer_ip_address = "45.79.245.251"

**_Use the NodeBalancer IP address to set the DNS A record for the website(s)._**

<br>


### Configure Application VMs - Ansible

Once the infrastructure has been created, cd to the `ansible/` directory. From here, we'll set a few inventory variables, and the IP addresses of the hosts.

In `inventories/production/hosts` set the IP address of each instance created. Use the external IP addresses provided by the terraform output.

Using `inventories/production/group_vars/all`, set the variables for the site in `/common-main.yml` and `/main.yml`:

        ## main.yml
        # Website/Blog settings
        domain: "example.com"
        staging_domain: "staging.example.com"
        site_name: "site"


        ## common-main.yml
        ruby_version: '2.7'
        bundler_version: '2.1.4'

        ssh__keys:
        - key: ssh-key-of-the-deployer

After setting these variables appropriately for your project, use the `site.yml` playbook to install the configuration. 

        ansible-playbook site.yml -i inventories/production/hosts --diff

_Since this is the first time running the playbook on the instances, we won't be using --check as we need to install python first_

Using the defaulted configuration will result in a few convenient settings:

- A staging site is served at `/srv/{{site_name}}-staging/`
- A production site is served at `/srv/{{site-name}}/`
- A `jekyll` user can be used for deploys.
- An `ops` user exists to perform administrative actions as needed.

<br>

### Deploy a site with Jekyll

A default Jekyll site exists in the `/jekyll-site` repo. This site will use Capistrano for deploys to the instances.

Navigate to the jekyll-site directory. 

First, look in `config/deploy.rb` and set the ssh url of the repository storing the site.

Set the app instance IP addresses in `config/production.rb` and `config/staging.rb`. Additionally, ensure the `deploy_to` directories match the deploy directories set in the Ansible configuration.

From here, use Capistrano to deploy the site to the instances:

        bundle exec cap production deploy --trace

_`--dry-run` can be used to test the deploy_

### Wrapping up

If all the steps have been completed, the instances should be serving their static site content at the specified domains. To make the infrastructure even more secure, we can take a few additional steps to secure different aspects from the initial build.

First, navigate to `terraform/firewall.tf`. In this file, remove the inbound rules for port `22`. Since we have changed the default port to `8822` we can now close the traffic to this port completely. `apply` this change to the firewall.

Second, navigate to `ansible/inventories/production/hosts`. Notice that the `ansible_user` is set as `root` and the `ansible_port` is `22`. Change the port to `8822` and the user to the specified admin user (default: `ops`). _Root is used for initial ansible run as Linode only provides root access to start. After initial run is complete, port 22 is closed._