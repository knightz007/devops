resource "google_compute_disk" "dash_jenkins_persistent_disk" {
  name    = "jenkins-home"
  type    = "pd-ssd"
  zone    = "us-east1-b"
  size    = "15"
  project = "dash-terraform"
  labels = {
    environment = "dev"
  }
}

resource "google_compute_disk" "dash_nexus_persistent_disk" {
  name    = "nexus-pd"
  type    = "pd-ssd"
  zone    = "us-east1-b"
  size    = "10"
  project = "dash-terraform"
  labels = {
    environment = "dev"
  }
}

resource "google_compute_disk" "dash_prometheus_alert_disk" {
  name    = "prometheus-alert-pd"
  type    = "pd-ssd"
  zone    = "us-east1-b"
  size    = "5"
  project = "dash-terraform"
  labels = {
    environment = "dev"
  }
}

resource "google_compute_disk" "dash_prometheus_push_disk" {
  name    = "prometheus-push-pd"
  type    = "pd-ssd"
  zone    = "us-east1-b"
  size    = "5"
  project = "dash-terraform"
  labels = {
    environment = "dev"
  }
}

resource "google_compute_disk" "dash_prometheus_server_disk" {
  name    = "prometheus-server-pd"
  type    = "pd-ssd"
  zone    = "us-east1-b"
  size    = "5"
  project = "dash-terraform"
  labels = {
    environment = "dev"
  }
}

resource "google_compute_disk" "dash_grafana_persistent_disk" {
  name    = "grafana-server-pd"
  type    = "pd-ssd"
  zone    = "us-east1-b"
  size    = "5"
  project = "dash-terraform"
  labels = {
    environment = "dev"
  }
}

