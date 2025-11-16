resource "digitalocean_loadbalancer" "www-lb" {
    name   = "www-lb"
    region = "tor1"
    vpc_uuid = digitalocean_vpc.main.id

    forwarding_rule {
        entry_port       = 443
        entry_protocol   = "https"
        target_port      = 80
        target_protocol  = "http"
        certificate_name = digitalocean_certificate.cert.name
    }

    # SECURITY FIX: Health check on port 80 (HTTP) instead of 22 (SSH)
    healthcheck {
        port     = 80
        protocol = "http"
        path     = "/"
    }

    droplet_ids = [digitalocean_droplet.www-1.id, digitalocean_droplet.www-2.id]

    depends_on = [digitalocean_certificate.cert, digitalocean_domain.maximeconnollyxyz]
}