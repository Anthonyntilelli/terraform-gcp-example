# https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.3.1"
    }
  }
  required_version = ">= 1.4"
}
