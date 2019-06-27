
provider "digitalocean" {
    token = "${var.token}"
}

resource "digitalocean_droplet" "app-server" {
  name   = "app-server"
  image  = "centos-7-x64"
  region = "BLR1"
  size   = "8gb"
}
