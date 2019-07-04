
variable "do_token" {}
variable "pub_key" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

