resource "digitalocean_record" "CNAME-www" {
    domain = digitalocean_domain.maximeconnollyxyz.id
    type = "CNAME"
    name = "www"
    value = "@"
}

resource "digitalocean_record" "CNAME-secs1027" {
    domain = digitalocean_domain.maximeconnollyxyz.id
    type = "CNAME"
    name = "secs1027"
    value = "${digitalocean_database_cluster.mysql-secs1027.host}."
}

