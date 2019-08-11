# Specify the provider
provider "google" {
  credentials = "${file("../dash-terraform-credentials.json")}"
  project     = "${var.project_name}"
  region      = "${var.provider_region}"
  zone        = "${var.provider_zone}"
}

terraform {
  backend "gcs" {
    bucket      = "dashstatebucket"
    prefix      = "dev/cluster"
    credentials = "../dash-terraform-credentials.json"
  }
}

module "dev_k8_cluster" {
  source = "../../modules/k8_cluster"
}

output "cluster_master_ip" {
  value = "${module.dev_k8_cluster.cluster_master_ip}"
}
