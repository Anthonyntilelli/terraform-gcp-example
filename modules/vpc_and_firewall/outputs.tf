output "vpc_name" {
  value       = google_compute_network.vpc_network.name
  description = "Name of VPC network"
}
output "vpc_subnet" {
  value       = google_compute_subnetwork.subnets
  description = "list of vpc subnets"
}
