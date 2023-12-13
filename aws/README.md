# Terraform and GCP

A practice project to implement a simple [3 teir web application](./aws_3_teir.drawio.svg) in aws.

## Fill in data

1. Create a `terraform.tfvars` from example file.
2. Fill in Require data in provider.tf

## Prerequisite

1. Create AWS account.
2. Create a terraform IAM user with Admin permissions.
    - Authenticate to the AWS cli using Terraform IAM User.
3. Create [S3 bucket](https://developer.hashicorp.com/terraform/language/settings/backends/s3) for state and update provider.tf
