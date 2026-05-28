output "aws_account_id" {
  description = "AWS account ID used by Terraform"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region"
  value       = data.aws_region.current.region
}

output "availability_zone" {
  description = "Selected availability zone"
  value       = local.selected_availability_zone
}

output "ubuntu_ami_id" {
  description = "Dynamically selected Ubuntu AMI ID"
  value       = data.aws_ami.ubuntu.id
}

output "ubuntu_ami_name" {
  description = "Dynamically selected Ubuntu AMI name"
  value       = data.aws_ami.ubuntu.name
}

output "vpc_id" {
  description = "Created VPC ID"
  value       = module.networking.vpc_id
}

output "public_subnet_id" {
  description = "Created public subnet ID"
  value       = module.networking.public_subnet_id
}

output "k8s_instance_id" {
  description = "Kubernetes EC2 instance ID"
  value       = module.ec2_k8s.instance_id
}

output "k8s_server_public_ip" {
  description = "Kubernetes server public IP"
  value       = module.ec2_k8s.public_ip
}

output "k8s_server_public_dns" {
  description = "Kubernetes server public DNS"
  value       = module.ec2_k8s.public_dns
}

output "ssh_command" {
  description = "SSH command"
  value       = "ssh -i ~/.ssh/nodejs-k8s-key ubuntu@${module.ec2_k8s.public_ip}"
}

output "kubernetes_api_server" {
  description = "Kubernetes API server endpoint"
  value       = "https://${module.ec2_k8s.public_ip}:6443"
}

output "application_url" {
  description = "Node.js application URL"
  value       = "http://${module.ec2_k8s.public_ip}:${var.nodeport}"
}