aws_region  = "us-east-1"
project_name = "nodejs-k8s-cicd"
environment = "dev"
owner       = "aniket"

vpc_cidr           = "10.10.0.0/16"
public_subnet_cidr = "10.10.1.0/24"

instance_type    = "t3.medium"
root_volume_size = 30
root_volume_type = "gp3"

ubuntu_version = "22.04"
architecture   = "amd64"

key_name        = "nodejs-k8s-key"
public_key_path = "~/.ssh/nodejs-k8s-key.pub"

allowed_ssh_cidr = "0.0.0.0/0"
allowed_app_cidr = "0.0.0.0/0"

nodeport = 30080

kubernetes_version = "v1.31"
calico_version     = "v3.28.0"