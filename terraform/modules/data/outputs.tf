output "instance_id" {
  description = "ID de l'instance données."
  value       = openstack_compute_instance_v2.data.id
}

output "volume_id" {
  description = "ID du volume chiffré."
  value       = openstack_blockstorage_volume_v3.data.id
}
