# Bucket Module

Create a Storage buckets and access for service accounts

## Usage

```hcl

module "bucket-module" {
  source           = "./modules/bucket"
  name             = <Unique bucket name>
  service_accounts = <Service account email>
  terraform_account = <Terraform account email>
}

```

## Author

Module managed by [Anthony Tilelli](https://github.com/Anthonyntilelli).
