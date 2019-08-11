variable "vpc_id" {
  description = "describe your variable"
  default     = "default value"
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = "string"
}

variable "cluster_security_group_id" {
  description = "describe your variable"
  default     = "default value"
}

variable "iam_node_name" {
  description = "describe your variable"
  default     = "default value"
}
