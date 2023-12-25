provider "google" {
  project = var.gcp_projectid
  region  = var.gcp_region
  zone    = var.gcp_zone
}

resource "google_service_account" "service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_name
}

resource "google_project_iam_member" "project" {
  count = length(var.iam_role)
  project = var.gcp_projectid
  role    = var.iam_role[count.index]
  member  = google_service_account.service_account.member
}



