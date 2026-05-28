locals {
  name_prefix = "${var.project_name}-${var.environment}"

  selected_availability_zone = data.aws_availability_zones.available.names[0]

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}