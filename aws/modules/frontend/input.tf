variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "list of subnet ids"
}

variable "as_ws_id" {
  type        = string
  description = "autoscaling group id"
}
