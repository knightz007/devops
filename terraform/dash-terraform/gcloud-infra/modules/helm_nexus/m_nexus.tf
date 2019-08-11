resource "kubernetes_namespace" "nexus_namespace_resource" {
  metadata {
    name = "nexus"
  }
}

resource "kubernetes_persistent_volume" "dash_nexus_pv_resource" {
  metadata {
    name = "dash-nexus-volume"
  }
  spec {
    storage_class_name = "standard"
    capacity = {
      storage = "30Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "nexus-pd"
        fs_type = "ext4"
      }
    }
  }

  depends_on = [kubernetes_namespace.nexus_namespace_resource]
}

resource "kubernetes_persistent_volume_claim" "dash_nexus_pvc_resource" {
  metadata {
    name      = "dash-nexus-pvc"
    namespace = "nexus"
  }
  spec {
    storage_class_name = "standard"
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "30Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.dash_nexus_pv_resource.metadata.0.name}"
  }

  depends_on = [kubernetes_persistent_volume.dash_nexus_pv_resource]
}

resource "helm_release" "nexus-app-resource" {
  name      = "nexus-cd"
  chart     = "stable/sonatype-nexus"
  namespace = "nexus"

  provisioner "local-exec" {
    command = "sleep 30"
  }

  set {
    name  = "persistence.existingClaim"
    value = "dash-nexus-pvc"
  }

  set {
    name  = "nexus.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "nexusProxy.env.nexusHttpHost"
    value = "nexus-web.hopto.org"
  }

  set {
    name  = "nexusProxy.env.nexusDockerHost"
    value = "nexus-web.hopto.org"
  }


  depends_on = [kubernetes_persistent_volume_claim.dash_nexus_pvc_resource]
}

output "nexus_deployment_name" {
  value = "${helm_release.nexus-app-resource.name}"
}
