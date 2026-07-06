variable "project_name" { type = string }
variable "network_cidr" { type = string }
variable "subnet_presentation_cidr" { type = string }
variable "subnet_application_cidr" { type = string }
variable "subnet_data_cidr" { type = string }
variable "admin_allowed_cidr" { type = string }

# Reseau prive et sous-reseaux (un par tier)
resource "openstack_networking_network_v2" "main" {
  name           = "${var.project_name}-net"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "presentation" {
  name       = "${var.project_name}-subnet-presentation"
  network_id = openstack_networking_network_v2.main.id
  cidr       = var.subnet_presentation_cidr
  ip_version = 4
}

resource "openstack_networking_subnet_v2" "application" {
  name       = "${var.project_name}-subnet-application"
  network_id = openstack_networking_network_v2.main.id
  cidr       = var.subnet_application_cidr
  ip_version = 4
}

resource "openstack_networking_subnet_v2" "data" {
  name       = "${var.project_name}-subnet-data"
  network_id = openstack_networking_network_v2.main.id
  cidr       = var.subnet_data_cidr
  ip_version = 4
}

# --- Security Groups en couches ---

resource "openstack_networking_secgroup_v2" "presentation" {
  name        = "${var.project_name}-sg-presentation"
  description = "Tier presentation : expose HTTPS a Internet"
}

resource "openstack_networking_secgroup_v2" "application" {
  name        = "${var.project_name}-sg-application"
  description = "Tier application : accessible uniquement depuis la presentation"
}

resource "openstack_networking_secgroup_v2" "data" {
  name        = "${var.project_name}-sg-data"
  description = "Tier donnees : accessible uniquement depuis l'application"
}

# Presentation : HTTPS ouvert au monde, SSH restreint a l'admin
resource "openstack_networking_secgroup_rule_v2" "pres_https_in" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.presentation.id
}

resource "openstack_networking_secgroup_rule_v2" "pres_ssh_admin" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_allowed_cidr
  security_group_id = openstack_networking_secgroup_v2.presentation.id
}

# Application : n'accepte que la presentation (port 8080)
resource "openstack_networking_secgroup_rule_v2" "app_from_presentation" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_group_id   = openstack_networking_secgroup_v2.presentation.id
  security_group_id = openstack_networking_secgroup_v2.application.id
}

resource "openstack_networking_secgroup_rule_v2" "app_ssh_admin" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_allowed_cidr
  security_group_id = openstack_networking_secgroup_v2.application.id
}

# Donnees : n'accepte que l'application (PostgreSQL 5432), jamais Internet
resource "openstack_networking_secgroup_rule_v2" "data_from_application" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_group_id   = openstack_networking_secgroup_v2.application.id
  security_group_id = openstack_networking_secgroup_v2.data.id
}

resource "openstack_networking_secgroup_rule_v2" "data_ssh_admin" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_allowed_cidr
  security_group_id = openstack_networking_secgroup_v2.data.id
}

output "network_id" { value = openstack_networking_network_v2.main.id }
output "subnet_presentation_id" { value = openstack_networking_subnet_v2.presentation.id }
output "subnet_application_id" { value = openstack_networking_subnet_v2.application.id }
output "subnet_data_id" { value = openstack_networking_subnet_v2.data.id }
output "sg_presentation_id" { value = openstack_networking_secgroup_v2.presentation.id }
output "sg_application_id" { value = openstack_networking_secgroup_v2.application.id }
output "sg_data_id" { value = openstack_networking_secgroup_v2.data.id }
