resource "digitalocean_loadbalancer" "www-lb" {
    name = "www-lb"
    region = "tor1"

    forwarding_rule {
      entry_port = 443
      entry_protocol = "https"

      target_port = 80
      target_protocol = "http"

      certificate_name = digitalocean_certificate.cert.name
    }

    healthcheck {
      port = 22
      protocol = "tcp"
    }

    droplet_ids = [digitalocean_droplet.www-1.id, digitalocean_droplet.www-2.id]

    depends_on = [ digitalocean_certificate.cert, digitalocean_domain.maximeconnollyxyz ]
}