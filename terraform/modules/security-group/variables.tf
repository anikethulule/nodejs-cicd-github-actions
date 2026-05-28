variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH and Kubernetes API"
  type        = string
}

variable "allowed_app_cidr" {
  description = "CIDR allowed for application access"
  type        = string
}

variable "nodeport" {
  description = "NodePort for application"
  type        = number
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}