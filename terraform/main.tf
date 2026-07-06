locals {
  common_tags = {
    project     = var.project_name
    environment = var.environment
    owner       = "equipe-nordcloud"
  }
}

module "network" {
  source = "./modules/network"

  project_name             = var.project_name
  network_cidr             = var.network_cidr
  subnet_presentation_cidr = var.subnet_presentation_cidr
  subnet_application_cidr  = var.subnet_application_cidr
  subnet_data_cidr         = var.subnet_data_cidr
  admin_allowed_cidr       = var.admin_allowed_cidr
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "data" {
  source = "./modules/data"

  project_name      = var.project_name
  image_name        = var.image_name
  flavor_name       = var.flavor_data
  network_id        = module.network.network_id
  subnet_id         = module.network.subnet_data_id
  security_group_id = module.network.sg_data_id
  tags              = local.common_tags
}

module "application" {
  source = "./modules/application"

  project_name      = var.project_name
  image_name        = var.image_name
  flavor_name       = var.flavor_application
  instance_count    = var.app_instance_count
  network_id        = module.network.network_id
  subnet_id         = module.network.subnet_application_id
  security_group_id = module.network.sg_application_id
  tags              = local.common_tags
}

module "presentation" {
  source = "./modules/presentation"

  project_name      = var.project_name
  image_name        = var.image_name
  flavor_name       = var.flavor_presentation
  network_id        = module.network.network_id
  subnet_id         = module.network.subnet_presentation_id
  security_group_id = module.network.sg_presentation_id
  tags              = local.common_tags
}
