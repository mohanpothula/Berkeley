variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "node_name" {
  type        = string
  description = "Name of the node group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for the node group"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "policy_arns" {
  type        = list(string)
  description = "IAM policies to attach to node group role"
  default     = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

variable "ami_type" {
  type        = string
  description = "AMI type for the EKS node group"
  default     = "AL2_x86_64"
}


variable "desired_size" {
  type        = number
  default     = 2
}

variable "max_size" {
  type        = number
  default     = 2
}

variable "min_size" {
  type        = number
  default     = 2
}
