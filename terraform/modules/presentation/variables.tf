variable "project_name" {
  description = "Préfixe de nommage des ressources."
  type        = string
}

variable "image_name" {
  description = "Nom de l'image système de l'instance."
  type        = string
}

variable "flavor_name" {
  description = "Gabarit (flavor) de l'instance présentation."
  type        = string
}

variable "network_id" {
  description = "ID du réseau privé."
  type        = string
}

variable "subnet_id" {
  description = "ID du sous-réseau présentation."
  type        = string
}

variable "security_group_id" {
  description = "ID du Security Group présentation."
  type        = string
}

variable "tags" {
  description = "Tags communs (FinOps / conformité)."
  type        = map(string)
}
