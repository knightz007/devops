resource "kubernetes_namespace" "monitoring_namespace_resource" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_persistent_volume" "dash_prometheus_alert_pv_resource" {
  metadata {
    name = "dash-prometheus-alert-volume"
  }
  spec {
    storage_class_name = "standard"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "prometheus-alert-pd"
        fs_type = "ext4"
      }
    }
  }

  depends_on = [kubernetes_namespace.monitoring_namespace_resource]
}

resource "kubernetes_persistent_volume_claim" "dash_prometheus_alert_pvc_resource" {
  metadata {
    name      = "dash-prometheus-alert-pvc"
    namespace = "monitoring"
  }
  spec {
    storage_class_name = "standard"
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.dash_prometheus_alert_pv_resource.metadata.0.name}"
  }

  depends_on = [kubernetes_persistent_volume.dash_prometheus_alert_pv_resource]
}

resource "kubernetes_persistent_volume" "dash_prometheus_push_pv_resource" {
  metadata {
    name = "dash-prometheus-push-volume"
  }
  spec {
    storage_class_name = "standard"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "prometheus-push-pd"
        fs_type = "ext4"
      }
    }
  }

  depends_on = [kubernetes_namespace.monitoring_namespace_resource]
}

resource "kubernetes_persistent_volume_claim" "dash_prometheus_push_pvc_resource" {
  metadata {
    name      = "dash-prometheus-push-pvc"
    namespace = "monitoring"
  }
  spec {
    storage_class_name = "standard"
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.dash_prometheus_push_pv_resource.metadata.0.name}"
  }

  depends_on = [kubernetes_persistent_volume.dash_prometheus_push_pv_resource]
}

resource "kubernetes_persistent_volume" "dash_prometheus_server_pv_resource" {
  metadata {
    name = "dash-prometheus-server-volume"
  }
  spec {
    storage_class_name = "standard"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "prometheus-server-pd"
        fs_type = "ext4"
      }
    }
  }

  depends_on = [kubernetes_namespace.monitoring_namespace_resource]
}

resource "kubernetes_persistent_volume_claim" "dash_prometheus_server_pvc_resource" {
  metadata {
    name      = "dash-prometheus-server-pvc"
    namespace = "monitoring"
  }
  spec {
    storage_class_name = "standard"
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.dash_prometheus_server_pv_resource.metadata.0.name}"
  }

  depends_on = [kubernetes_persistent_volume.dash_prometheus_server_pv_resource]
}

resource "helm_release" "prometheus-app-resource" {
  name      = "prometheus"
  chart     = "stable/prometheus"
  namespace = "monitoring"

  provisioner "local-exec" {
    command = "sleep 30"
  }

  set {
    name  = "alertmanager.persistentVolume.existingClaim"
    value = "dash-prometheus-alert-pvc"
  }

  set {
    name  = "pushgateway.persistentVolume.existingClaim"
    value = "dash-prometheus-push-pvc"
  }

  set {
    name  = "server.persistentVolume.existingClaim"
    value = "dash-prometheus-server-pvc"
  }

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  depends_on = [kubernetes_persistent_volume_claim.dash_prometheus_server_pvc_resource,
    kubernetes_persistent_volume_claim.dash_prometheus_alert_pvc_resource,
  kubernetes_persistent_volume_claim.dash_prometheus_push_pvc_resource]
}

output "prometheus_deployment_name" {
  value = "${helm_release.prometheus-app-resource.name}"
}

