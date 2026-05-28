resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(pathexpand(var.public_key_path))

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-key"
  })
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user-data.sh", {
    kubernetes_version = var.kubernetes_version
    calico_version     = var.calico_version
    nodeport           = var.nodeport
  })

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-k8s-server"
    AMI  = var.ami_name
  })
}