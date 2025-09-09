resource "digitalocean_record" "A-root" {
    domain = digitalocean_domain.maximeconnollyxyz.id
    type = "A"
    name = "@"
    value = digitalocean_loadbalancer.www-lb.ip
}

