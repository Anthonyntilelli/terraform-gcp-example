variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
}

variable "region" {
  description = "Default gcloud region"
  type        = string
}

variable "credentials_file_path" {
  description = "Path to the JSON file used to describe your account credentials"
  type        = string
}

variable "terraform_service_email" {
  description = "Terraform service account email"
  type        = string
}
