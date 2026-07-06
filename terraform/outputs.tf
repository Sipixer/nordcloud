output "presentation_ip" {
  description = "IP publique du tier présentation (point d'entrée)."
  value       = module.presentation.floating_ip
}

output "network_id" {
  description = "ID du réseau privé NordCloud."
  value       = module.network.network_id
}
