variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the cluster"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS cluster"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the cluster"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, uat, prod)"
}
