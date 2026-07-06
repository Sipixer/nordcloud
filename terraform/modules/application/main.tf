variable "project_name" { type = string }
variable "image_name" { type = string }
variable "flavor_name" { type = string }
variable "instance_count" { type = number }
variable "network_id" { type = string }
variable "subnet_id" { type = string }
variable "security_group_id" { type = string }
variable "tags" { type = map(string) }

data "openstack_images_image_v2" "os" {
  name        = var.image_name
  most_recent = true
}

resource "openstack_networking_port_v2" "this" {
  count              = var.instance_count
  name               = "${var.project_name}-application-port-${count.index}"
  network_id         = var.network_id
  security_group_ids = [var.security_group_id]

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

# Pas d'IP publique : le tier application reste prive
resource "openstack_compute_instance_v2" "this" {
  count       = var.instance_count
  name        = "${var.project_name}-application-${count.index}"
  image_id    = data.openstack_images_image_v2.os.id
  flavor_name = var.flavor_name
  metadata    = var.tags

  network {
    port = openstack_networking_port_v2.this[count.index].id
  }
}

output "instance_ids" { value = openstack_compute_instance_v2.this[*].id }
