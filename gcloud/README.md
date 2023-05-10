# Terraform and GCP

A practice project to implement a subset of [Example Google Infrastructure](https://gcp.solutions/diagram/ls-secondary-analysis) for time and cost constraints.

- Data Lab and Big query are not included.

## Fill in data

1. Create a `terraform.tfvars` from example file.
2. Fill in Require data in provider.tf

## Prerequisite

1. Enable Api:
    - cloudresourcemanager.googleapis.com
    - cloudbilling.googleapis.com
    - compute.googleapis.com
    - iam.googleapis.com

2. Create bucket for state and update main.tf

3. Create service account for terraform as Project Editor.

4. Download Service account key and store as `./credentials/Terraform.no-git.json`
