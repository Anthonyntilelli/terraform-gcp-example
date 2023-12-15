variable "vpc_cidr_block" {
  type        = string
  description = "Cidr block for entire vpc e.g. 10.0.0.0/16"
  default     = "10.0.0.0/16"
}

variable "network_name" {
  type        = string
  description = "Name of vpc"
  default     = "primary"
}

variable "subnet_cidrs" {
  type        = list(object({ cidr = string, avz = string }))
  description = "Cidr block and availability_zone (must be in default Region) for subnets"
  default     = [
    {cidr = "10.0.1.0/24", avz = "us-east-1d"},
    {cidr = "10.0.2.0/24", avz = "us-east-1a"}
  ]
}
