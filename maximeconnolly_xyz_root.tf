resource "digitalocean_domain" "maximeconnollyxyz" {
    name = "maximeconnolly.xyz"
    ip_address = digitalocean_loadbalancer.www-lb.ip
}