variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "cidr block for the VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "list of subnet ids"
}

variable "frontend_sg_id" {
  type        = string
  description = "ID for the frontend security group"
}
