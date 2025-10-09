resource "aws_iam_role" "node_group_role" {
  name = "${var.node_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "${var.node_name}-eks-node-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.node_group_role.name
  policy_arn = each.value
}

resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_name
  subnet_ids      = var.subnet_ids
  node_role_arn   = aws_iam_role.node_group_role.arn
  ami_type        = var.ami_type
  
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
