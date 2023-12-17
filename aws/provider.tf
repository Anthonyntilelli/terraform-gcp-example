terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
  backend "s3" {
    bucket = "<enter bucket here>"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.6"
}

provider "aws" {
  region = "us-east-1"
}
provider "random" {}
