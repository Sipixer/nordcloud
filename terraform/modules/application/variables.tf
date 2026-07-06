variable "project_name" {
  description = "Préfixe de nommage des ressources."
  type        = string
}

variable "image_name" {
  description = "Nom de l'image système des instances."
  type        = string
}

variable "flavor_name" {
  description = "Gabarit (flavor) des instances application."
  type        = string
}

variable "instance_count" {
  description = "Nombre d'instances applicatives (scalabilité horizontale)."
  type        = number
}

variable "network_id" {
  description = "ID du réseau privé."
  type        = string
}

variable "subnet_id" {
  description = "ID du sous-réseau application."
  type        = string
}

variable "security_group_id" {
  description = "ID du Security Group application."
  type        = string
}

variable "tags" {
  description = "Tags communs (FinOps / conformité)."
  type        = map(string)
}
