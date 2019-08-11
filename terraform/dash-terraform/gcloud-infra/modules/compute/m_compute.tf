# Specify the provider
provider "google" {
  credentials = "${file("../../modules/provider/dash-terraform-credentials.json")}"
  project     = "${var.project_name}"
  region      = "${var.provider_region}"
  zone        = "${var.provider_zone}"
}

resource "google_compute_network" "vpc_network" {
  name                    = "${var.vpc_name}"
  auto_create_subnetworks = "true"
  # project                 = "${var.project_name}"
}

# Create compute instance
resource "google_compute_instance" "vm_instance" {
  name         = "${var.compute_instance_name}"
  machine_type = "${var.compute_instance_machine_type}"

  boot_disk {
    initialize_params {
      image = "${var.compute_instance_image}"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "${google_compute_network.vpc_network.self_link}"
    access_config {}
  }

}
