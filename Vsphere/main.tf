data "vsphere_datacenter" "datacenter" {
  for_each = var.virtual_machines
  name     = each.value.data_center
}

data "vsphere_network" "network" {
  for_each      = var.virtual_machines
  name          = each.value.network_interface
  datacenter_id = data.vsphere_datacenter.datacenter[each.key].id
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  for_each      = var.virtual_machines
  name          = each.value.datastore_cluster
  datacenter_id = data.vsphere_datacenter.datacenter[each.key].id
}

data "vsphere_compute_cluster" "cluster" {
  for_each      = var.virtual_machines
  name          = each.value.compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter[each.key].id
}

data "vsphere_virtual_machine" "template" {
  for_each      = var.virtual_machines
  name          = each.value.template_machine
  datacenter_id = data.vsphere_datacenter.datacenter[each.key].id
}

resource "vsphere_virtual_machine" "vm" {
  for_each = var.virtual_machines

  firmware             = "efi"
  name                 = each.key
  resource_pool_id     = data.vsphere_compute_cluster.cluster[each.key].resource_pool_id
  num_cpus             = each.value.number_of_cpu
  memory               = each.value.ram_MB
  guest_id             = each.value.guest_id
  folder               = each.value.folder_location
  datastore_cluster_id = data.vsphere_datastore_cluster.datastore_cluster[each.key].id
  network_interface {
    network_id = data.vsphere_network.network[each.key].id
  }
  disk {
    label = "disk0"
    # the Clone disk must be at a minimum, same size as template we can add more gb but not less then template size
    size = data.vsphere_virtual_machine.template[each.key].disks.0.size + each.value.primary_disk_additional_size_GB
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template[each.key].id

    customize {
      linux_options {
        host_name = each.key
        domain    = "example.com" # TODO: Add real domain
      }
      network_interface {
        ipv4_address = each.value.ipv4_address
        ipv4_netmask = each.value.netmask
      }
      ipv4_gateway = each.value.nic_gateway

      # The resolvers to query for DNS.
      dns_server_list = each.value.dns_server_list

      # This is the DNS 'search' in /etc/resolv.conf
      dns_suffix_list = ["example.com", "example.org"] # TODO:  Add real domain suffix

    }
  }
}

