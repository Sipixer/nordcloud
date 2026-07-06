data "openstack_images_image_v2" "system" {
  name        = var.image_name
  most_recent = true
}

resource "openstack_networking_port_v2" "data" {
  name               = "${var.project_name}-data-port"
  network_id         = var.network_id
  security_group_ids = [var.security_group_id]

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

# Pas d'IP publique : le tier données est le plus isolé.
resource "openstack_compute_instance_v2" "data" {
  name        = "${var.project_name}-data"
  image_id    = data.openstack_images_image_v2.system.id
  flavor_name = var.flavor_name
  metadata    = var.tags

  network {
    port = openstack_networking_port_v2.data.id
  }
}

# Volume chiffré : chiffrement des données au repos (conformité).
resource "openstack_blockstorage_volume_v3" "data" {
  name        = "${var.project_name}-data-volume"
  size        = var.volume_size
  volume_type = "classic-encrypted"
  metadata    = var.tags
}

resource "openstack_compute_volume_attach_v2" "data" {
  instance_id = openstack_compute_instance_v2.data.id
  volume_id   = openstack_blockstorage_volume_v3.data.id
}
