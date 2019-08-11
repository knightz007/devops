

resource "google_container_cluster" "devops_kube" {
  name     = "${var.cluster_name}"
  location = "${var.cluster_location}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # depends_on = [module.provider]
}

resource "google_container_node_pool" "devops_kube_nodes" {
  name       = "${var.node_pool_name}"
  location   = "${var.node_pool_location}"
  cluster    = "${google_container_cluster.devops_kube.name}"
  node_count = "${var.node_pool_node_count}"

  node_config {
    preemptible  = true
    machine_type = "${var.node_config_machine_type}"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "null_resource" "get-gcloud-credentials" {

  provisioner "local-exec" {
    # command = "gcloud beta container clusters get-credentials ${google_container_cluster.devops_kube.name} --region ${var.region} --project ${var.project_name}"
    command = "gcloud beta container clusters get-credentials ${google_container_cluster.devops_kube.name} --region ${var.provider_region} --project ${var.project_name}"

  }

  depends_on = [google_container_node_pool.devops_kube_nodes]

}

resource "null_resource" "wait_time" {

  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [null_resource.get-gcloud-credentials]

}

output "cluster_node_pool_name" {
  value = "${google_container_node_pool.devops_kube_nodes.name}"
}

output "cluster_id" {
  value = "${google_container_cluster.devops_kube.id}"
}

output "cluster_master_ip" {
  value = "${google_container_cluster.devops_kube.endpoint}"
}

output "cluster_name" {
  value = "${google_container_cluster.devops_kube.name}"
}
