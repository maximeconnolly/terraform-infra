resource "digitalocean_database_cluster" "mysql-secs1027" {
    name       = "secs1027"
    engine     = "mysql"
    version    = "8"
    size       = "db-s-1vcpu-1gb"
    region     = "tor1"
    node_count = 1  # NOTE: Consider increasing to 3 for high availability

    private_network_uuid = digitalocean_vpc.main.id

    tags = ["production", "database", "terraform"]

    lifecycle {
        prevent_destroy = true
    }
}