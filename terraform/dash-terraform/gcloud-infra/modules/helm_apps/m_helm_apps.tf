resource "kubernetes_namespace" "namespace_resource" {
  metadata {
    name = "${var.namespace_name}"
  }
}

resource "kubernetes_persistent_volume" "dash_pv_resource" {
  metadata {
    name = "${var.pv_name}"
  }
  spec {
    storage_class_name = "${var.pv_storage_class}"
    capacity = {
      storage = "${var.pv_storage_capacity}"
    }
    access_modes = "${var.pv_access_modes}"
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "${var.persistent_disk_name}"
        fs_type = "${var.persistent_disk_fs_type}"
      }
    }
  }

  depends_on = [kubernetes_namespace.namespace_resource]
}

resource "kubernetes_persistent_volume_claim" "dash_pvc_resource" {
  metadata {
    name      = "${var.pvc_name}"
    namespace = "${var.namespace_name}"
  }
  spec {
    storage_class_name = "${var.pv_storage_class}"
    access_modes       = "${var.pv_access_modes}"
    resources {
      requests = {
        storage = "${var.pv_storage_capacity}"
      }
    }
    volume_name = "${kubernetes_persistent_volume.dash_pv_resource.metadata.0.name}"
  }

  depends_on = [kubernetes_persistent_volume.dash_pv_resource]
}

# WIP
# Figure out how you would templatize 'set' blocks below - that is see 
# if we can pass 'set' blocks from the main tf file. This allows us to re-use
# the below resource block for different apps(ex jenkins, prometheus, grafana etc)

resource "helm_release" "app-resource" {
  name      = "${var.helm_release_name}"
  chart     = "${var.helm_chart_name}"
  namespace = "${var.namespace_name}"

  provisioner "local-exec" {
    command = "sleep 30"
  }

  set {
    name  = "persistence.existingClaim"
    value = "pvc_name"
  }

  set {
    name  = "master.adminPassword"
    value = "itsanup"
  }

  depends_on = [kubernetes_persistent_volume_claim.dash_pvc_resource]
}

