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

