variable "master_cluster_version" {
  description = "describe your variable"
  default     = "default value"
}

variable "master_cluster_endpoint" {
  description = "describe your variable"
  default     = "default value"
}

variable "master_cluster_ca_data" {
  description = "describe your variable"
  default     = "default value"
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = "string"
}

variable "node_security_group_id" {
  description = "describe your variable"
  default     = "default value"
}

variable "aws_subnet_ids" {
  type        = "list"
  description = "describe your variable"
  default     = ["default_value"]
}
