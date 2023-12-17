# Network Module

Create the fronted Load balancer
## Usage

```hcl
module "frontend" {
  source     = "./modules/frontend"
  vpc_id     = <vpc id>
  subnet_ids = <list of subnet ids>
  as_ws_id   = <auto scaling group id>
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_lb.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_as_ws_id"></a> [as\_ws\_id](#input\_as\_ws\_id) | autoscaling group id | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | list of subnet ids | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ELB"></a> [ELB](#output\_ELB) | Frontend Load balancer |
| <a name="output_frontend_sg_id"></a> [frontend\_sg\_id](#output\_frontend\_sg\_id) | frontend security group id |
<!-- END_TF_DOCS -->

## Update Readme

The readme use [Terraform-docs](https://github.com/terraform-docs/terraform-docs). Update that section with following command.

`terraform-docs markdown table --output-file README.md --output-mode inject .`

## Author

Module created by [Anthony Tilelli](https://github.com/Anthonyntilelli).
