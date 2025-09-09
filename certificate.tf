resource "digitalocean_certificate" "cert" {
    name = "lets-encrypt-www"
    type = "lets_encrypt"
    domains = [digitalocean_domain.maximeconnollyxyz.name]
    depends_on = [ digitalocean_domain.maximeconnollyxyz ]
}