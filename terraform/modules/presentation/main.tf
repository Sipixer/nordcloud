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
  name               = "${var.project_name}-presentation-port"
  network_id         = var.network_id
  security_group_ids = [var.security_group_id]

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

resource "openstack_compute_instance_v2" "this" {
  name        = "${var.project_name}-presentation"
  image_id    = data.openstack_images_image_v2.os.id
  flavor_name = var.flavor_name
  metadata    = var.tags

  network {
    port = openstack_networking_port_v2.this.id
  }
}

# IP publique : seul le tier presentation est expose a Internet
resource "openstack_networking_floatingip_v2" "this" {
  pool = "Ext-Net"
}

resource "openstack_networking_floatingip_associate_v2" "this" {
  floating_ip = openstack_networking_floatingip_v2.this.address
  port_id     = openstack_networking_port_v2.this.id
}

output "floating_ip" { value = openstack_networking_floatingip_v2.this.address }
