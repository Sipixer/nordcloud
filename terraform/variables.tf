variable "project_name" {
  type    = string
  default = "nordcloud"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "region" {
  type    = string
  default = "GRA11"
}

variable "image_name" {
  type    = string
  default = "Debian 12"
}

variable "admin_allowed_cidr" {
  type    = string
  default = "203.0.113.0/24"
}

variable "network_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_presentation_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "subnet_application_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "subnet_data_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "flavor_presentation" {
  type    = string
  default = "b3-8"
}

variable "flavor_application" {
  type    = string
  default = "b3-8"
}

variable "flavor_data" {
  type    = string
  default = "b3-16"
}

variable "app_instance_count" {
  type    = number
  default = 2
}
