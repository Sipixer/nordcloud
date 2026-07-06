output "network_id" {
  description = "ID du réseau privé."
  value       = openstack_networking_network_v2.private.id
}

output "subnet_presentation_id" {
  description = "ID du sous-réseau présentation."
  value       = openstack_networking_subnet_v2.presentation.id
}

output "subnet_application_id" {
  description = "ID du sous-réseau application."
  value       = openstack_networking_subnet_v2.application.id
}

output "subnet_data_id" {
  description = "ID du sous-réseau données."
  value       = openstack_networking_subnet_v2.data.id
}

output "sg_presentation_id" {
  description = "ID du Security Group présentation."
  value       = openstack_networking_secgroup_v2.presentation.id
}

output "sg_application_id" {
  description = "ID du Security Group application."
  value       = openstack_networking_secgroup_v2.application.id
}

output "sg_data_id" {
  description = "ID du Security Group données."
  value       = openstack_networking_secgroup_v2.data.id
}
