locals {
  # All loadbalancer ip and Heathchecks ips
  lb_and_hc_ip = [
    "35.191.0.0/16",
    "130.211.0.0/22",
    "209.85.152.0/22",
    "209.85.204.0/22"
  ]
  admin_ports = ["22", "3389"]
}

resource "google_compute_network" "vpc_network" {
  name                    = "${var.vpc_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  name                     = "${var.vpc_name}-subnets${count.index}"
  ip_cidr_range            = var.vpc_subnets[count.index].ip_cidr_range
  region                   = var.vpc_subnets[count.index].region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = var.vpc_subnets[count.index].private_ip_google_access
  count                    = length(var.vpc_subnets)
}

resource "google_compute_firewall" "admin_via_iap" {
  name          = "${var.vpc_name}-vpc-allow-ssh-rdp-from-iap"
  network       = google_compute_network.vpc_network.name
  description   = "https://cloud.google.com/iap/docs/using-tcp-forwarding"
  direction     = "INGRESS"
  priority      = 65534               # same as `default-allow-ssh/rdp`
  source_ranges = ["35.235.240.0/20"] # IAP ip
  allow {
    protocol = "tcp"
    ports    = local.admin_ports
  }
}

resource "google_compute_firewall" "ingress_allow_internal" {
  name          = "${var.vpc_name}-subnets${count.index}-allow-internal"
  description   = "Allow-internal for ${var.vpc_name}-subnets${count.index}"
  network       = google_compute_network.vpc_network.id
  direction     = "INGRESS"
  priority      = 65534 # same as `default-allow-internal`
  source_ranges = [var.vpc_subnets[count.index].ip_cidr_range]
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
  count = length(var.vpc_subnets)
}

resource "google_compute_firewall" "http_heathcheck_fw" {
  count         = var.allow_heath_check_and_loadbalancer == true ? 1 : 0
  name          = "${var.vpc_name}-allow-http-heathcheck"
  network       = google_compute_network.vpc_network.name
  description   = "Allow http(s) heathchecks and loadbalancer"
  direction     = "INGRESS"
  priority      = 6000
  source_ranges = local.lb_and_hc_ip
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "8443"]
  }
}

resource "google_compute_firewall" "admin_heathcheck_fw" {
  count         = var.allow_ssh_and_rdp_heath_check == true ? 1 : 0
  name          = "${var.vpc_name}-allow-admin-heathcheck"
  network       = google_compute_network.vpc_network.name
  description   = "Allow ssh and RDP through heathchecks and loadbalancer"
  direction     = "INGRESS"
  priority      = 6100
  source_ranges = local.lb_and_hc_ip
  allow {
    protocol = "tcp"
    ports    = local.admin_ports
  }
}
