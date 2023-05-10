variable "vpc_name" {
  description = "Name of vpc"
  type        = string
}

variable "vpc_subnets" {
  description = "Subnet settings for VPC"
  type        = list(object({ ip_cidr_range = string, region = string, private_ip_google_access = bool }))
}

variable "allow_heath_check_and_loadbalancer" {
  description = "Create firewall rule for tcp: 80, 443, 8080 and 8443 for heath checks and loadblancers if set to true"
  type        = bool
}

variable "allow_ssh_and_rdp_heath_check" {
  description = "Create firewall rule for tcp: 22 and 3389 for heath checks if set to true"
}
