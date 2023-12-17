locals {
  subnet_ids = [for subnet in module.network.subnets : subnet.id]
}

module "network" {
  source = "./modules/network"
}

module "backend" {
  source         = "./modules/backend"
  vpc_id         = module.network.vpc.id
  vpc_cidr       = module.network.vpc.cidr_block
  subnet_ids     = local.subnet_ids
  frontend_sg_id = module.frontend.frontend_sg_id
}

module "frontend" {
  source     = "./modules/frontend"
  vpc_id     = module.network.vpc.id
  subnet_ids = local.subnet_ids
  as_ws_id   = module.backend.autoscaling_group.id
}
