output "instance_ids" {
  description = "IDs des instances application."
  value       = openstack_compute_instance_v2.application[*].id
}
