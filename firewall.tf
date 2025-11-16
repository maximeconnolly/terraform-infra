resource "digitalocean_firewall" "web" {
    name = "web-firewall"

    droplet_ids = [
        digitalocean_droplet.www-1.id,
        digitalocean_droplet.www-2.id
    ]

    # Allow HTTP from anywhere (load balancer will handle HTTPS)
    inbound_rule {
        protocol         = "tcp"
        port_range       = "80"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    # Allow HTTPS from anywhere
    inbound_rule {
        protocol         = "tcp"
        port_range       = "443"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    # Allow SSH from anywhere (consider restricting to specific IPs)
    # TODO: Replace with specific IP addresses for production
    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    # Allow all outbound traffic
    outbound_rule {
        protocol              = "tcp"
        port_range            = "1-65535"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    outbound_rule {
        protocol              = "udp"
        port_range            = "1-65535"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    outbound_rule {
        protocol              = "icmp"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }
}
