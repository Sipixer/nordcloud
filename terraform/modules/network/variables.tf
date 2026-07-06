variable "project_name" {
  description = "Préfixe de nommage des ressources réseau."
  type        = string
}

variable "network_cidr" {
  description = "Plage CIDR du réseau privé NordCloud."
  type        = string
}

variable "subnet_presentation_cidr" {
  description = "CIDR du sous-réseau du tier présentation."
  type        = string
}

variable "subnet_application_cidr" {
  description = "CIDR du sous-réseau du tier application."
  type        = string
}

variable "subnet_data_cidr" {
  description = "CIDR du sous-réseau du tier données."
  type        = string
}

variable "admin_allowed_cidr" {
  description = "CIDR autorisé pour l'administration SSH (bastion / VPN)."
  type        = string
}
