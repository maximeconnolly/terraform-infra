resource "digitalocean_vpc" "main" {
    name     = "vpc-tor1-production"
    region   = "tor1"
    ip_range = "10.10.0.0/16"

    description = "Production VPC for secure private networking"
}
