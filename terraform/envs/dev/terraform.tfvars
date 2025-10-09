aws_region      = "ap-southeast-1"
aws_profile     = "default"
environment     = "dev"
cluster_version = "1.31"
cluster_role_arn = "arn:aws:iam::493512622090:role/eks-cluster-role-dev"

alb_name        = "eks-alb-dev"
alb_internal    = false
alb_port        = 80
alb_protocol    = "HTTP"
alb_target_type = "ip"

vpc_id = "vpc-05ce1bcfd2bf1865e"

public_subnets = [
  "subnet-028fd6e17843c24c0",
  "subnet-043f86190601934ad"
]
