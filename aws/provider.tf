/* CREATE
 - Provider
 - Backend
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
  backend "s3" {
    bucket = "tf-state-98076"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.6"
}

provider "aws" {
  region = "us-east-1"
}
