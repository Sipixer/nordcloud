# Réseau privé et sous-réseaux, un par tier.
resource "openstack_networking_network_v2" "private" {
  name           = "${var.project_name}-network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "presentation" {
  name       = "${var.project_name}-subnet-presentation"
  network_id = openstack_networking_network_v2.private.id
  cidr       = var.subnet_presentation_cidr
  ip_version = 4
}

resource "openstack_networking_subnet_v2" "application" {
  name       = "${var.project_name}-subnet-application"
  network_id = openstack_networking_network_v2.private.id
  cidr       = var.subnet_application_cidr
  ip_version = 4
}

resource "openstack_networking_subnet_v2" "data" {
  name       = "${var.project_name}-subnet-data"
  network_id = openstack_networking_network_v2.private.id
  cidr       = var.subnet_data_cidr
  ip_version = 4
}

# Security Groups en couches : un par tier.
resource "openstack_networking_secgroup_v2" "presentation" {
  name        = "${var.project_name}-sg-presentation"
  description = "Tier présentation : expose HTTPS à Internet"
}

resource "openstack_networking_secgroup_v2" "application" {
  name        = "${var.project_name}-sg-application"
  description = "Tier application : accessible uniquement depuis la présentation"
}

resource "openstack_networking_secgroup_v2" "data" {
  name        = "${var.project_name}-sg-data"
  description = "Tier données : accessible uniquement depuis l'application"
}

# Présentation : HTTPS ouvert au monde, SSH restreint à l'admin.
resource "openstack_networking_secgroup_rule_v2" "presentation_https_from_internet" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.presentation.id
}

resource "openstack_networking_secgroup_rule_v2" "presentation_ssh_from_admin" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_allowed_cidr
  security_group_id = openstack_networking_secgroup_v2.presentation.id
}

# Application : n'accepte que la présentation (port 8080), SSH restreint à l'admin.
resource "openstack_networking_secgroup_rule_v2" "application_http_from_presentation" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_group_id   = openstack_networking_secgroup_v2.presentation.id
  security_group_id = openstack_networking_secgroup_v2.application.id
}

resource "openstack_networking_secgroup_rule_v2" "application_ssh_from_admin" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_allowed_cidr
  security_group_id = openstack_networking_secgroup_v2.application.id
}

# Données : n'accepte que l'application (PostgreSQL 5432), jamais Internet.
resource "openstack_networking_secgroup_rule_v2" "data_postgres_from_application" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_group_id   = openstack_networking_secgroup_v2.application.id
  security_group_id = openstack_networking_secgroup_v2.data.id
}

resource "openstack_networking_secgroup_rule_v2" "data_ssh_from_admin" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_allowed_cidr
  security_group_id = openstack_networking_secgroup_v2.data.id
}
