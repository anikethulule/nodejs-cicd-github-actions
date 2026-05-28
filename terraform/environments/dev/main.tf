module "networking" {
  source = "../../modules/networking"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = local.selected_availability_zone
  common_tags        = local.common_tags
}

module "security_group" {
  source = "../../modules/security-group"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.networking.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  allowed_app_cidr = var.allowed_app_cidr
  nodeport         = var.nodeport
  common_tags      = local.common_tags
}

module "ec2_k8s" {
  source = "../../modules/ec2-k8s"

  project_name       = var.project_name
  environment        = var.environment
  ami_id             = data.aws_ami.ubuntu.id
  ami_name           = data.aws_ami.ubuntu.name
  instance_type      = var.instance_type
  subnet_id          = module.networking.public_subnet_id
  security_group_id  = module.security_group.security_group_id
  key_name           = var.key_name
  public_key_path    = var.public_key_path
  root_volume_size   = var.root_volume_size
  root_volume_type   = var.root_volume_type
  nodeport           = var.nodeport
  kubernetes_version = var.kubernetes_version
  calico_version     = var.calico_version
  common_tags        = local.common_tags
}