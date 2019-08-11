resource "kubernetes_namespace" "anchore_namespace_resource" {
  metadata {
    name = "anchore"
  }
}

resource "helm_release" "anchore-app-resource" {
  name      = "anchore"
  chart     = "stable/anchore-engine"
  namespace = "anchore"

  provisioner "local-exec" {
    command = "sleep 30"
  }

  set {
    name  = "anchoreApi.service.type"
    value = "LoadBalancer"
  }

  depends_on = [kubernetes_namespace.anchore_namespace_resource]
}

output "anchore_deployment_name" {
  value = "${helm_release.anchore-app-resource.name}"
}
