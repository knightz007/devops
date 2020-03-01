variable "project_name" {
  description = "Name of the project"
  default     = "dash-terraform"
}

variable "provider_region" {
  description = "Region"
  default     = "us-east1-b"
}

variable "provider_zone" {
  description = "zone"
  default     = "us-east1-b"
}

variable "cluster_name" {
  description = "describe your variable"
  default     = "dev-cluster"
}

variable "cluster_location" {
  description = "describe your variable"
  default     = "us-east1-b"
}

variable "node_pool_name" {
  description = "describe your variable"
  default     = "dev-cluster-node-pool"
}

variable "node_pool_location" {
  description = "describe your variable"
  default     = "us-east1-b"
}

variable "node_pool_node_count" {
  description = "describe your variable"
  default     = 2
}

variable "node_config_machine_type" {
  description = "describe your variable"
  default     = "n1-standard-1"
}
