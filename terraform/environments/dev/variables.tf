variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "nodejs-k8s-cicd"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner name"
  type        = string
  default     = "aniket"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.10.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for Kubernetes server"
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Root EBS volume size"
  type        = number
  default     = 30
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "ubuntu_version" {
  description = "Ubuntu version"
  type        = string
  default     = "22.04"
}

variable "architecture" {
  description = "AMI architecture"
  type        = string
  default     = "amd64"
}

variable "key_name" {
  description = "AWS key pair name"
  type        = string
  default     = "nodejs-k8s-key"
}

variable "public_key_path" {
  description = "Local public key path"
  type        = string
  default     = "~/.ssh/nodejs-k8s-key.pub"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH and Kubernetes API"
  type        = string
}

variable "allowed_app_cidr" {
  description = "CIDR allowed for application access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "nodeport" {
  description = "Kubernetes NodePort"
  type        = number
  default     = 30080
}

variable "kubernetes_version" {
  description = "Kubernetes package repository version"
  type        = string
  default     = "v1.31"
}

variable "calico_version" {
  description = "Calico CNI version"
  type        = string
  default     = "v3.28.0"
}