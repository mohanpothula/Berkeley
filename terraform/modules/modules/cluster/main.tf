resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Name        = var.cluster_name
  }
}
