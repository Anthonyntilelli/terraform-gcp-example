resource "google_compute_instance_template" "subnet_template" {
  name_prefix  = "${var.name}-${var.template_subnet[count.index].name}-template-"
  machine_type = var.template_machine_size
  disk {
    source_image = var.template_source_image
    auto_delete  = true
    boot         = true
  }
  network_interface {
    subnetwork = var.template_subnet[count.index].id
    access_config {
      # Ephemeral Public IP
    }
  }
  metadata_startup_script = file(var.template_startup_script)
  lifecycle {
    create_before_destroy = true
  }

  service_account {
    email  = var.service_email
    scopes = []
  }
  count = length(var.template_subnet)
}

resource "google_compute_health_check" "http_hc" {
  count               = var.enable_http_load_balancer == true ? 1 : 0
  name                = "${var.name}-http-health-check-${count.index}"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

resource "google_compute_health_check" "ssh_hc" {
  count               = var.enable_ssh_heath_checks == true ? 1 : 0
  name                = "${var.name}-ssh-health-check-${count.index}"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  tcp_health_check {
    port = "22"
  }
}

data "google_compute_zones" "available" {
  count  = length(var.template_subnet)
  region = var.template_subnet[count.index].region
  status = "UP"
}

resource "google_compute_instance_group_manager" "igm" {
  name               = "${var.name}-${count.index}-igm"
  base_instance_name = var.name
  zone               = data.google_compute_zones.available[count.index].names[0]

  version {
    instance_template = google_compute_instance_template.subnet_template[count.index].id
  }
  target_size = var.group_size_per_zone

  named_port {
    name = "http"
    port = 80
  }

  named_port {
    name = "ssh"
    port = 22
  }

  # HTTP Heath Check
  dynamic "auto_healing_policies" {
    for_each = var.enable_http_load_balancer == true ? ["filler"] : []
    content {
      health_check      = google_compute_health_check.http_hc[0].id
      initial_delay_sec = 300
    }
  }

  # SSH Heath Check
  dynamic "auto_healing_policies" {
    for_each = var.enable_ssh_heath_checks == true ? ["filler"] : []
    content {
      health_check      = google_compute_health_check.ssh_hc[0].id
      initial_delay_sec = 300
    }
  }

  count      = length(google_compute_instance_template.subnet_template)
  depends_on = [data.google_compute_zones.available]
}

resource "google_compute_backend_service" "backend" {
  count         = var.enable_http_load_balancer == true ? 1 : 0
  name          = "${var.name}-backend-service"
  health_checks = [google_compute_health_check.http_hc[0].id]
  protocol      = "HTTP"
  port_name     = "http"
  dynamic "backend" {
    for_each = toset(google_compute_instance_group_manager.igm[*].instance_group)
    content {
      group = backend.value
    }
  }
}

# [count.index] is only for enable and disable below
resource "google_compute_url_map" "urlmap" {
  count           = var.enable_http_load_balancer == true ? 1 : 0
  name            = "${var.name}-urlmap"
  default_service = google_compute_backend_service.backend[count.index].id
}

resource "google_compute_target_http_proxy" "proxy" {
  count   = var.enable_http_load_balancer == true ? 1 : 0
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.urlmap[count.index].id
}

resource "google_compute_global_forwarding_rule" "proxy" {
  count      = var.enable_http_load_balancer == true ? 1 : 0
  name       = "${var.name}-global-rule"
  target     = google_compute_target_http_proxy.proxy[count.index].id
  port_range = "80"
}
