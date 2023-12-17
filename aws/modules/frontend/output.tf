output "frontend_sg_id" {
  value       = aws_security_group.frontend.id
  description = "frontend security group id"
}

output "elb" {
  value       = aws_lb.frontend
  description = "Frontend Load balancer"
}
