
variable "region" {
  description = "AWS Region to deploy Server in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.medium"
}

variable "allowed_ports" {
  description = "List of Ports to open"
  type        = list
  default     = ["80", "443", "22", "8080", "8081", "8082"]
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}

variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map
  default = {
    Owner       = "Alex Tchaikovski"
    Project     = "Jenkins"
    Purpose     = "Learning"
  }
}

variable "domain_name" {
  default = "tchaikovski.link"
}

variable "host_name" {
  type = string
  default = "jenkins"
}