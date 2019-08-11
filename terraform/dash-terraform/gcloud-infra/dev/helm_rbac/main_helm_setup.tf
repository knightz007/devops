data "terraform_remote_state" "k8_cluster_state" {
  backend = "gcs"
  config = {
    bucket      = "dashstatebucket"
    credentials = "${file("../dash-terraform-credentials.json")}"
    prefix      = "dev/cluster"
  }
}
provider "kubernetes" {
  # host           = "https://${var.cluster_master_ip}"
  host           = "https://${data.terraform_remote_state.k8_cluster_state.outputs.cluster_master_ip}"
  config_context = "gke_${var.project_name}_${var.provider_region}_${var.cluster_name}"
}

module "helm_rbac_setup" {
  source = "../../modules/helm_rbac"
}
