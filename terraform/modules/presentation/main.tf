data "openstack_images_image_v2" "system" {
  name        = var.image_name
  most_recent = true
}

resource "openstack_networking_port_v2" "presentation" {
  name               = "${var.project_name}-presentation-port"
  network_id         = var.network_id
  security_group_ids = [var.security_group_id]

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

resource "openstack_compute_instance_v2" "presentation" {
  name        = "${var.project_name}-presentation"
  image_id    = data.openstack_images_image_v2.system.id
  flavor_name = var.flavor_name
  metadata    = var.tags

  network {
    port = openstack_networking_port_v2.presentation.id
  }
}

# IP publique : seul le tier présentation est exposé à Internet.
resource "openstack_networking_floatingip_v2" "presentation" {
  pool = "Ext-Net"
}

resource "openstack_networking_floatingip_associate_v2" "presentation" {
  floating_ip = openstack_networking_floatingip_v2.presentation.address
  port_id     = openstack_networking_port_v2.presentation.id
}
