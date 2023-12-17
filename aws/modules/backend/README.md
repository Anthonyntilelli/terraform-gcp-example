# Network Module

Create the backend database, autoscaling group and security groups.

## Usage

```hcl
module "backend" {
  source     = "./modules/backend"
  vpc_id     = <vpc id>
  vpc_cidr   = <vpc cidr block.
  subnet_ids = <list of subnet ids>
  frontend_sg_id = <frontend security group id>
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.web_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.web_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_db_instance.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_launch_template.web_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_string.database](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_frontend_sg_id"></a> [frontend\_sg\_id](#input\_frontend\_sg\_id) | ID for the frontend security group | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | list of subnet ids | `list(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | cidr block for the VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscaling_group"></a> [autoscaling\_group](#output\_autoscaling\_group) | data on webserver autoscaling group |
| <a name="output_sql_password"></a> [sql\_password](#output\_sql\_password) | password for database |
<!-- END_TF_DOCS -->

## Update Readme

The readme use [Terraform-docs](https://github.com/terraform-docs/terraform-docs). Update that section with following command.

`terraform-docs markdown table --output-file README.md --output-mode inject .`

## Author

Module created by [Anthony Tilelli](https://github.com/Anthonyntilelli).
