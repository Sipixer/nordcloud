output "instance_id" {
  description = "ID de l'instance présentation."
  value       = openstack_compute_instance_v2.presentation.id
}

output "floating_ip" {
  description = "IP publique du tier présentation."
  value       = openstack_networking_floatingip_v2.presentation.address
}
