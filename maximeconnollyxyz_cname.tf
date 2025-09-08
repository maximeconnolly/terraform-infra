resource "digitalocean_record" "CNAME-www" {
    domain = digitalocean_domain.maximeconnollyxyz.id
    type = "CNAME"
    name = "www"
    value = "@"
}