variable "project_name" {
  description = "Name of the project"
  default     = "dash-terraform"
}

variable "provider_region" {
  description = "Region"
  default     = "us-central1"
}

variable "provider_zone" {
  description = "zone"
  default     = "us-central1-a"
}

variable "vpc_name" {
  description = "Name of vpc"
  default     = "dash-network"
}

variable "compute_instance_name" {
  description = "describe your variable"
  default     = "dash-instance1"
}

variable "compute_instance_machine_type" {
  description = "describe your variable"
  default     = "f1-micro"
}

variable "compute_instance_image" {
  description = "describe your variable"
  default     = "debian-cloud/debian-9"
}
