variable "namespace_name" {
  description = "describe your variable"
  default     = "namespace_name"
}

variable "pv_name" {
  description = "describe your variable"
  default     = "pv_name"
}

variable "pv_storage_class" {
  description = "describe your variable"
  default     = "standard"
}

variable "pv_storage_capacity" {
  description = "describe your variable"
  default     = "10Gi"
}

variable "pv_access_modes" {
  type        = "list"
  description = "describe your variable"
  default     = ["ReadWriteOnce"]
}

variable "persistent_disk_name" {
  description = "describe your variable"
  default     = "persistent_disk_name"
}

variable "persistent_disk_fs_type" {
  description = "describe your variable"
  default     = "ext4"
}

variable "pvc_name" {
  description = "describe your variable"
  default     = "pvc_name"
}

variable "helm_release_name" {
  description = "describe your variable"
  default     = "helm_release_name"
}

variable "helm_chart_name" {
  description = "describe your variable"
  default     = "helm_chart_name"
}
