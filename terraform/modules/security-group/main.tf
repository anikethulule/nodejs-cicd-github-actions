resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.environment}-k8s-sg"
  description = "Security group for single-node Kubernetes server"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Kubernetes API server from trusted IP"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Application NodePort access"
    from_port   = var.nodeport
    to_port     = var.nodeport
    protocol    = "tcp"
    cidr_blocks = [var.allowed_app_cidr]
  }

  ingress {
    description = "HTTP access for future ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_app_cidr]
  }

  ingress {
    description = "HTTPS access for future ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.allowed_app_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-k8s-sg"
  })
}