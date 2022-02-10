terraform {
  backend "s3" {
    bucket = "prod-env"
    key    = "./terraform.tfstate"
    region = "us-east-1"                                # e.g. us-east-1
    endpoint = "us-southeast-1.linodeobjects.com"       # e.g. us-east-1.linodeobjects.com
    skip_credentials_validation = true                  # Terraform will ask AWS about credential validation instead of Linode if this is enabled.
  }
}