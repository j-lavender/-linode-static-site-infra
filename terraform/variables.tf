variable "token" {
  description = "API token of the Linode Account"
  type        = string
}
variable "site" {
  description = "FQDN of the static site"
  type        = string
}

variable "environment" {
  description = "Environment of the infrastructure (staging/production/dev/etc..)"
  type        = string
}

variable "region" {
  description = "Region to host the infrastructure"
  type        = string
}

variable "root_pass" {
  description = "The root password for the bastion instance."
  default     = "default-root-password"
  type        = string
  sensitive   = true
}

variable "ssh_key" {
  description = "Filepath of id_rsa.pub for root access to VMs."
}

variable "app_servers" {
  description = "Details describing the vm instances for the app"
  type        = list(any)
}

variable "bastion_server" {
  description = "Details describing the bastion instance."
  type        = map(any)
}