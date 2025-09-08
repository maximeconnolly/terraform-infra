resource "digitalocean_database_cluster" "mysql-secs1027" {
    name = "secs1027"
    engine = "mysql"
    version = "8"
    size = "db-s-1vcpu-1gb"
    region = "tor1"
    node_count = 1
}