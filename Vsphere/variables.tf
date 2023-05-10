# Provider Credentials
variable "vsphere_user" {
  description = "Username for the vsphere user"
  sensitive   = true
  type        = string
}
variable "vsphere_password" {
  description = "Password for the vsphere user"
  sensitive   = true
  type        = string
}
variable "vsphere_server" {
  description = "Url or IP for the Vsphere server"
}

variable "virtual_machines" {
  description = "map of Virtual Machines, the key is the virtual machine name."
  type = map(object(
    {
      number_of_cpu                   = number
      ram_MB                          = number
      primary_disk_additional_size_GB = number # Additional GB on top of Template disk size
      guest_id                        = string
      network_interface               = string
      datastore_cluster               = string
      compute_cluster                 = string
      data_center                     = string
      folder_location                 = string
      template_machine                = string
      ipv4_address                    = string
      netmask                         = number
      nic_gateway                     = string
      dns_server_list                 = list(string)
    }
  ))
}
