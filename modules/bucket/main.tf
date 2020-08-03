resource "google_storage_bucket" "bucket" {
  name          = var.name
  location      = "US"
  force_destroy = true
}

resource "google_storage_bucket_access_control" "admin_rule" {
  bucket = google_storage_bucket.bucket.name
  role   = "OWNER"
  entity = "user-${var.terraform_account}"
}

resource "google_storage_bucket_access_control" "service_account_rule" {
  bucket = google_storage_bucket.bucket.name
  role   = "OWNER"
  entity = "user-${var.service_accounts[count.index]}"
  count  = length(var.service_accounts)
}
