output "ingress_vpc_name" {
  value       = module.ingress_vpc_and_firewall.vpc_name
  description = "Name of VPC network"
}

output "ingress_subnet" {
  value       = module.ingress_vpc_and_firewall.vpc_subnet
  description = "list of vpc subnets"
}

output "internal_vpc_name" {
  value       = module.internal_vpc_and_firewall.vpc_name
  description = "Name of VPC network"
}

output "internal_subnet" {
  value       = module.internal_vpc_and_firewall.vpc_subnet
  description = "list of vpc subnets"
}

output "ingress_cluster_img" {
  value       = module.ingress_cluster.img
  description = "List of manage instance groups"
}

output "internal_cluster_img" {
  value       = module.intenal_cluster.img
  description = "List of manage instance groups"
}
