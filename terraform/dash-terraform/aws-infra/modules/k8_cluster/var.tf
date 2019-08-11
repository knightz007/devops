variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = "string"
}

variable "cluster-arn" {
  description = "describe your variable"
  default     = "default value"
}

variable "cluster_sg_id" {
  description = "describe your variable"
  default     = "default value"
}

# variable "aws_subnet_ids" {
#   description = "describe your variable"
#   default     = "default value"
# }

variable "aws_subnet_ids" {
  type        = "list"
  description = "describe your variable"
  default     = ["default_value"]
}

variable "iam_cluster_policy" {
  description = "describe your variable"
  default     = "default value"
}

variable "iam_service_policy" {
  description = "describe your variable"
  default     = "default value"
}
