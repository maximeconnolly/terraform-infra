resource "digitalocean_record" "CNAME-www" {
    domain = digitalocean_domain.maximeconnollyxyz.id
    type = "CNAME"
    name = "www"
    value = "maximeconnolly.xyz."
}

# SECURITY FIX: Removed public database CNAME record
# Database should only be accessed via private network from droplets
# Original CNAME: secs1027 -> database host (REMOVED for security)

