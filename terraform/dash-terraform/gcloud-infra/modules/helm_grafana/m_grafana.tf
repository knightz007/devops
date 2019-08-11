# resource "kubernetes_namespace" "monitoring_namespace_resource" {
#   metadata {
#     name = "monitoring"
#   }
# }

resource "kubernetes_persistent_volume" "dash_grafana_pv_resource" {
  metadata {
    name = "dash-grafana-volume"
  }
  spec {
    storage_class_name = "standard"
    capacity = {
      storage = "30Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "grafana-server-pd"
        fs_type = "ext4"
      }
    }
  }

  # depends_on = [kubernetes_namespace.monitoring_namespace_resource]
}

resource "kubernetes_persistent_volume_claim" "dash_grafana_pvc_resource" {
  metadata {
    name      = "dash-grafana-pvc"
    namespace = "monitoring"
  }
  spec {
    storage_class_name = "standard"
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "30Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.dash_grafana_pv_resource.metadata.0.name}"
  }

  depends_on = [kubernetes_persistent_volume.dash_grafana_pv_resource]
}

resource "helm_release" "grafana-app-resource" {
  name      = "grafana"
  chart     = "stable/grafana"
  namespace = "monitoring"

  provisioner "local-exec" {
    command = "sleep 30"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.existingClaim"
    value = "dash-grafana-pvc"
  }

  depends_on = [kubernetes_persistent_volume_claim.dash_grafana_pvc_resource]
}

output "grafana_deployment_name" {
  value = "${helm_release.grafana-app-resource.name}"
}
