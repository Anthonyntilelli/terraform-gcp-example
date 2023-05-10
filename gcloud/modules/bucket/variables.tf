variable "name" {
  description = "Name of Bucket"
  type        = string
}

variable "service_accounts" {
  description = "service account owners of buckets"
  type        = list(string)
}

variable "terraform_account" {
  description = "service account used by Terraform"
  type        = string
}
