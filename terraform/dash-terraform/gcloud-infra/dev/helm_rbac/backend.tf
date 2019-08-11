terraform {
  backend "gcs" {
    bucket      = "dashstatebucket"
    prefix      = "dev/cluster_rbac"
    credentials = "../dash-terraform-credentials.json"
  }
}
