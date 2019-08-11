provider "google" {
  credentials = "${file("../../dash-terraform-credentials.json")}"
  project     = "dash-terraform"
  region      = "us-east1"
}

terraform {
  backend "gcs" {
    bucket      = "dashstatebucket"
    prefix      = "dev/cluster_disks"
    credentials = "../../dash-terraform-credentials.json"
  }
}

module "helm_disks" {
  source = "../../../modules/helm_disks"
}
