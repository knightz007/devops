data "terraform_remote_state" "k8_cluster_state" {
  backend = "gcs"
  config = {
    bucket      = "dashstatebucket"
    credentials = "${file("../dash-terraform-credentials.json")}"
    prefix      = "dev/cluster"
  }
}

provider "helm" {
  kubernetes {
    host = "https://${data.terraform_remote_state.k8_cluster_state.outputs.cluster_master_ip}"
  }
  install_tiller  = true
  service_account = "tiller"
  namespace       = "kube-system"
}

module "helm-jenkins" {
  source = "../../modules/helm_jenkins"
}

module "helm-nexus" {
  source = "../../modules/helm_nexus"
}

module "helm-anchore" {
  source = "../../modules/helm_anchore"
}

module "helm-prometheus" {
  source = "../../modules/helm_prometheus"
}

module "helm-grafana" {
  source = "../../modules/helm_grafana"
}

output "jenkins_deployment_name" {
  value = "${module.helm-jenkins.jenkins_deployment_name}"
}

output "anchore_deployment_name" {
  value = "${module.helm-anchore.anchore_deployment_name}"
}

output "nexus_deployment_name" {
  value = "${module.helm-nexus.nexus_deployment_name}"
}

output "prometheus_deployment_name" {
  value = "${module.helm-prometheus.prometheus_deployment_name}"
}
