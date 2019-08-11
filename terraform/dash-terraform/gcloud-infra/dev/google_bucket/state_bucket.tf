# Specify the provider
provider "google" {
  credentials = "${file("../dash-terraform-credentials.json")}"
  project     = "${var.project_name}"
  region      = "${var.provider_region}"
  zone        = "${var.provider_zone}"
}

resource "google_storage_bucket" "state_bucket" {
  name          = "dashstatebucket"
  storage_class = "MULTI_REGIONAL"
  location      = "us"
}

# resource "google_storage_bucket_acl" "state-bucket-acl" {
#   bucket         = "${google_storage_bucket.state_bucket.name}"
#   predefined_acl = "readwrite"
# }
