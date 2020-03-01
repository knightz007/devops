variable "project_name" {
  description = "Name of the project"
  default     = "dash-terraform"
}

variable "provider_region" {
  description = "Region"
  default     = "us-east1-b"
}

variable "cluster_name" {
  description = "describe your variable"
  default     = "dev-cluster"
}

variable "cluster_master_ip" {
  description = "describe your variable"
  default     = ""
}
