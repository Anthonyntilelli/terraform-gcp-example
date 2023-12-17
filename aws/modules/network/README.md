# Network Module

Create the vpc and subnets. Creates the VPC in default Region.

## Usage

```hcl

module "network-module" {
  source         = "./modules/network"
  network_name   = <Network name>
  vpc_cidr_block = <cidr block>
  subnet_cidrs   = <list of subnets>
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
| [aws_internet_gateway.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_subnet.subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of vpc | `string` | `"primary"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | Cidr block and availability\_zone (must be in default Region) for subnets | `list(object({ cidr = string, avz = string }))` | <pre>[<br>  {<br>    "avz": "us-east-1d",<br>    "cidr": "10.0.1.0/24"<br>  },<br>  {<br>    "avz": "us-east-1a",<br>    "cidr": "10.0.2.0/24"<br>  }<br>]</pre> | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | Cidr block for entire vpc e.g. 10.0.0.0/16 | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets"></a> [subnets](#output\_subnets) | lists of Subnets |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | VPC of the network |
<!-- END_TF_DOCS -->

## Update Readme

The readme use [Terraform-docs](https://github.com/terraform-docs/terraform-docs). Update that section with following command.

`terraform-docs markdown table --output-file README.md --output-mode inject .`

## Author

Module created by [Anthony Tilelli](https://github.com/Anthonyntilelli).
