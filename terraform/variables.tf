variable "project_id" {
  default = "ikosolapov-tests"
}

variable base_image {
  default = "ubuntu-1804-bionic-v20181203a"
}

variable "master_machine_type" {
  default = "n1-standard-4"
}

variable "node_machine_type" {
  default = "n1-standard-4"
}

variable "masters_enabled" {
  description = "Number of enabled kubernetes masters"
  default     = 1
}
