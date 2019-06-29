resource "digitalocean_droplet" "app-server" {
    name   = "AppServer"
    image  = "centos-7-x64"
    region = "BLR1"
//    size   = "1gb"
    size   = "1gb"
//    size   = "8gb"
    resize_disk = "false"

    ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]
    //ssh_keys = ["${var.ssh_fingerprint}"]
    
}

output "ip" {
    value = "${digitalocean_droplet.app-server.ipv4_address}"
}


# Create a new SSH key
resource "digitalocean_ssh_key" "default" {
  name       = "Vagrant CiServerLocal SSH Key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_firewall" "app-server" {
  name = "only-22-80-and-443"

  // 22, 80, 8000, 8200, 8300, 9001

  droplet_ids = ["${digitalocean_droplet.app-server.id}"]

  inbound_rule {
      protocol           = "tcp"
      port_range         = "22"
      //source_addresses   = ["192.168.1.0/24", "2002:1:2::/48"]
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
      protocol           = "tcp"
      port_range         = "80"
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
      protocol           = "tcp"
      port_range         = "8000"
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
      protocol           = "tcp"
      port_range         = "8200"
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
      protocol           = "tcp"
      port_range         = "8300"
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
      protocol           = "tcp"
      port_range         = "9001"
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
      protocol           = "tcp"
      port_range         = "443"
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
      protocol           = "icmp"
      source_addresses   = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
      protocol                = "tcp"
      port_range              = "53"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
      protocol                = "udp"
      port_range              = "53"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
      protocol                = "icmp"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
  }

  # http/https connection
  outbound_rule  {
      protocol                       = "tcp"
      port_range                     = "80"
      destination_addresses   = ["0.0.0.0/0", "::/0"]

    #   destination_addresses          = ["${var.allowed_outbound_http_addresses}"]
    #   destination_tags               = ["${var.allowed_outbound_http_tags}"]
    #   destination_droplet_ids        = ["${var.allowed_outbound_http_droplet_ids}"]
    #   destination_load_balancer_uids = ["${var.allowed_outbound_http_load_balancer_uids}"]
    }
    outbound_rule {
      protocol                       = "tcp"
      port_range                     = "443"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    #   destination_addresses          = ["${var.allowed_outbound_https_addresses}"]
    #   destination_tags               = ["${var.allowed_outbound_https_tags}"]
    #   destination_droplet_ids        = ["${var.allowed_outbound_https_droplet_ids}"]
    #   destination_load_balancer_uids = ["${var.allowed_outbound_https_load_balancer_uids}"]
    }
  
}