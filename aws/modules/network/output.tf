output "vpc" {
  value       = aws_vpc.primary
  description = "VPC of the network"
}

output "subnets" {
  value       = aws_subnet.subnets
  description = "lists of Subnets"
}

