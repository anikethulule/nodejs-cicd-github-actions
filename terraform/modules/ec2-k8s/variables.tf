variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Kubernetes server"
  type        = string
}

variable "ami_name" {
  description = "AMI name for tagging"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "public_key_path" {
  description = "Local public key path"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
}

variable "root_volume_type" {
  description = "Root volume type"
  type        = string
}

variable "nodeport" {
  description = "Application NodePort"
  type        = number
}

variable "kubernetes_version" {
  description = "Kubernetes minor version repository. Example: v1.31, v1.32"
  type        = string
}

variable "calico_version" {
  description = "Calico CNI version"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}