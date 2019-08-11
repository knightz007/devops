variable "provider_region" {
  description = "Region"
  default     = "us-east1"
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = "string"
}
