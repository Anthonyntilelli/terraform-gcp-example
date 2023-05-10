provider "google" {
  region      = var.region
  project     = var.project_id
  credentials = file(var.credentials_file_path)
  version     = "~> 3.30"
}

# At this time, variable is not allowed here
terraform {
  backend "gcs" {
    bucket = <Set bucket name here>
    prefix = "terraform/state"
    credentials = "./credentials/Terraform.no-git.json"
  }
}
