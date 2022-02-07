Jekyll Site Configuration
==============

This role automates the configuration for Jekyll static sites on Ubuntu20 instances. Ruby is installed to support the use of Jekyll. Bundler is installed to support the use of Capistrano for deploys.

Use `deploy_dirs` to set the directory for deploys.

Role Variables
--------

        site_name: "example-site"       # Name of the static-site (no spaces).
        deploy_dirs:                    # List of deploy directories to create.
          - "/srv/{{ site_name }}/"
        deploy_user: "jekyll"           # User for deploys.
        deploy_group: "jekyll"          # Group of deploy user.

        ruby_version: "2.7"             # The version of Ruby to install. (v2.3 -> 2.7)
        bundler_version: "2.1.4"        # The Bundler version.

        ssh_keys: []                    # SSH Key for deploy user access.