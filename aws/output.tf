output "DNS_name" {
  value = module.frontend.elb.dns_name
}

output "database_password" {
  sensitive = true
  value     = module.backend.sql_password
}
