variable "project_name" { type = string }
variable "image_name" { type = string }
variable "flavor_name" { type = string }
variable "network_id" { type = string }
variable "subnet_id" { type = string }
variable "security_group_id" { type = string }
variable "tags" { type = map(string) }

data "openstack_images_image_v2" "os" {
  name        = var.image_name
  most_recent = true
}

resource "openstack_networking_port_v2" "this" {
  name               = "${var.project_name}-data-port"
  network_id         = var.network_id
  security_group_ids = [var.security_group_id]

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

# Pas d'IP publique : le tier donnees est le plus isole
resource "openstack_compute_instance_v2" "this" {
  name        = "${var.project_name}-data"
  image_id    = data.openstack_images_image_v2.os.id
  flavor_name = var.flavor_name
  metadata    = var.tags

  network {
    port = openstack_networking_port_v2.this.id
  }
}

# Volume de donnees chiffre (chiffrement au repos - conformite)
resource "openstack_blockstorage_volume_v3" "data" {
  name        = "${var.project_name}-data-volume"
  size        = 100
  volume_type = "classic-encrypted"
  metadata    = var.tags
}

resource "openstack_compute_volume_attach_v2" "data" {
  instance_id = openstack_compute_instance_v2.this.id
  volume_id   = openstack_blockstorage_volume_v3.data.id
}

output "instance_id" { value = openstack_compute_instance_v2.this.id }
output "volume_id" { value = openstack_blockstorage_volume_v3.data.id }
