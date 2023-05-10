# Instance and Load balancer module

Creates a managed instance group and Http load balancer.

- Loadbalancer fail if a firewall rule to allow http load balancer and heath checks is not present.

## Usage

```hcl
module "cluster_module" {
  source = "./modules/instance_and_loadblancer"

  name                      = <Unique name>
  template_startup_script   = <Start up file.sh>
  template_source_image     = <os image>
  template_machine_size     = <machine size>
  template_subnet           = <Subnet>
  group_size_per_zone       = <number of vms per subnet>
  service_email             = <service account email>
  enable_http_load_balancer = <bool>
  enable_ssh_heath_checks   = <bool>
}
```

## Author

Module managed by [Anthony Tilelli](https://github.com/Anthonyntilelli).
