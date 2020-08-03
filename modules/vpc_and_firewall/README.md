# VPC and Firewall Module

Creates a vpc with Firewall rules
Firewall Rules:

- Allow ssh and rdp via IAP proxy
- Allow internal Vpc communication
- Allow heath check and load balancer traffic, if enabled.

## Usage

```hcl
module "vpc_and_firewall_module" {
  source = "./modules/vpc_and_firewall"
  vpc_name = <unique name for vpc, subnets and firewall rules>
  vpc_subnets = [
    {
      ip_cidr_range            = <ip range for subnet>
      region                   = <region>,
      private_ip_google_access = <bool>
    }
    # Repeat above for each subnet
  ]
  allow_heath_check_and_loadbalancer = <bool>
  allow_ssh_and_rdp_heath_check      = <bool>
}

```

## Author

Module managed by [Anthony Tilelli](https://github.com/Anthonyntilelli).
