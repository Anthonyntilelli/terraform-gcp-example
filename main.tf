resource "google_service_account" "ingress_buckets" {
  account_id   = "ingress-buckets"
  display_name = "Ingress Buckets"
  description  = "Allow ingress cluster to access ingress buckets (Does not need AIM role)"
}

resource "google_service_account" "internal_buckets" {
  account_id   = "internal-buckets"
  display_name = "Internal Buckets"
  description  = "Used to allow Internal cluster to access Internal buckets (Does not need AIM role)"
}

module "meta-bucket" {
  source            = "./modules/bucket"
  name              = "metadata-09vm"
  service_accounts  = [google_service_account.ingress_buckets.email]
  terraform_account = var.terraform_service_email
}

module "raw-bucket" {
  source            = "./modules/bucket"
  name              = "raw-dwa342"
  service_accounts  = [google_service_account.internal_buckets.email, google_service_account.ingress_buckets.email]
  terraform_account = var.terraform_service_email
}

module "process-bucket" {
  source            = "./modules/bucket"
  name              = "process-data-29892dw"
  service_accounts  = [google_service_account.internal_buckets.email]
  terraform_account = var.terraform_service_email
}

module "ingress_vpc_and_firewall" {
  source   = "./modules/vpc_and_firewall"
  vpc_name = "ingress"
  vpc_subnets = [
    {
      ip_cidr_range            = "10.128.0.0/20",
      region                   = "us-central1",
      private_ip_google_access = true
    },
    {
      ip_cidr_range            = "10.138.0.0/20"
      region                   = "us-west1",
      private_ip_google_access = true
    },
    {
      ip_cidr_range            = "10.142.0.0/20",
      region                   = "us-east1",
      private_ip_google_access = true
    }
  ]
  allow_heath_check_and_loadbalancer = true
  allow_ssh_and_rdp_heath_check      = false
}

module "internal_vpc_and_firewall" {
  source   = "./modules/vpc_and_firewall"
  vpc_name = "cluster"
  vpc_subnets = [
    {
      name                     = "cluster1",
      ip_cidr_range            = "10.150.0.0/20",
      region                   = "us-central1",
      private_ip_google_access = true
    },
    {
      name                     = "cluster2",
      ip_cidr_range            = "10.152.0.0/20"
      region                   = "us-west1",
      private_ip_google_access = true
    }
  ]
  allow_heath_check_and_loadbalancer = false
  allow_ssh_and_rdp_heath_check      = true
}

module "ingress_cluster" {
  source = "./modules/instance_and_loadblancer"

  name                      = "ingress"
  template_startup_script   = "files/ingress_startup.sh"
  template_source_image     = "debian-cloud/debian-10"
  template_machine_size     = "f1-micro"
  template_subnet           = module.ingress_vpc_and_firewall.vpc_subnet
  group_size_per_zone       = 2
  service_email             = google_service_account.ingress_buckets.email
  enable_http_load_balancer = true
  enable_ssh_heath_checks   = false
}

module "intenal_cluster" {
  source = "./modules/instance_and_loadblancer"

  name                      = "cluster"
  template_startup_script   = "files/cluster_startup.sh"
  template_source_image     = "debian-cloud/debian-10"
  template_machine_size     = "f1-micro"
  template_subnet           = module.internal_vpc_and_firewall.vpc_subnet
  group_size_per_zone       = 2
  enable_http_load_balancer = false
  enable_ssh_heath_checks   = true
  service_email             = google_service_account.internal_buckets.email
}
