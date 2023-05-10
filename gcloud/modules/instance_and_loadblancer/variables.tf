variable "group_size_per_zone" {
  description = "Number of instances per zone"
  type        = number
}

variable "name" {
  description = "Name for all created resources"
  type        = string
}

variable "template_machine_size" {
  description = "Ingress machine size"
  type        = string
}

variable "template_source_image" {
  description = "Source boot image for template"
  type        = string
}

variable "template_startup_script" {
  description = "File location to start up script for template"
  type        = string
}

variable "template_subnet" {
  description = "list of subnets for instance group"
  type        = list
}

variable "enable_http_load_balancer" {
  description = "Create a Http loadbalancer and heathchecks for igm"
  type        = bool
}

variable "enable_ssh_heath_checks" {
  description = "Create a ssh heathchecks for igm"
  type        = bool
}

variable "service_email" {
  description = "Email of service account for igm"
  type        = string
}
