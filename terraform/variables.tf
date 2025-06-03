variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "ssh_user" {
  description = "Username for SSH login"
  type        = string
  default     = "ansible"
}

variable "ssh_pub_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/ansible.pub"
}

