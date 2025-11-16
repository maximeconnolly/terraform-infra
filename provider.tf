terraform {
    required_version = ">= 1.5.0"
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "~> 2.66.0"
        }
    }
}

variable "do_token" {
    description = "DigitalOcean API token for authentication"
    type        = string
    sensitive   = true
}

variable "pvt_key" {
    description = "Path to SSH private key file"
    type        = string
    sensitive   = true
}

provider "digitalocean" {
    token = var.do_token
}

data "digitalocean_ssh_key" "terraform" {
    name = "lenovo-max"
}