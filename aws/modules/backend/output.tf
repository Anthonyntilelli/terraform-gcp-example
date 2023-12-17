output "sql_password" {
  sensitive   = true
  value       = random_string.database.result
  description = "password for database"
}

output "autoscaling_group" {
  value       = aws_autoscaling_group.web_servers
  description = "data on webserver autoscaling group"
}
