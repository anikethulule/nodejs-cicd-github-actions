output "instance_id" {
  description = "Kubernetes server instance ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Kubernetes server public IP"
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "Kubernetes server public DNS"
  value       = aws_instance.this.public_dns
}