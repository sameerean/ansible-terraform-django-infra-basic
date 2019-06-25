
provider "digitalocean" {
    token = "${var.token}"
}

resource "digitalocean_droplet" "app-server" {
  image  = "centos-7-x64"
  name   = "app-server"
  region = "BLR1"
  size   = "8gb"
}
