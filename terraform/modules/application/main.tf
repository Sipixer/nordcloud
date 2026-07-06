data "openstack_images_image_v2" "system" {
  name        = var.image_name
  most_recent = true
}

resource "openstack_networking_port_v2" "application" {
  count              = var.instance_count
  name               = "${var.project_name}-application-port-${count.index}"
  network_id         = var.network_id
  security_group_ids = [var.security_group_id]

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

# Pas d'IP publique : le tier application reste privé.
resource "openstack_compute_instance_v2" "application" {
  count       = var.instance_count
  name        = "${var.project_name}-application-${count.index}"
  image_id    = data.openstack_images_image_v2.system.id
  flavor_name = var.flavor_name
  metadata    = var.tags

  network {
    port = openstack_networking_port_v2.application[count.index].id
  }
}
