terraform {
  backend "gcs" {
    bucket      = "dashstatebucket"
    prefix      = "dev/cluster_tools"
    credentials = "../dash-terraform-credentials.json"
  }
}
