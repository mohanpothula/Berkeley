variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile to use"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, uat, prod)"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS cluster"
}

variable "alb_name"        { type = string }
variable "alb_internal"    { type = bool }
variable "alb_port"        { type = number }
variable "alb_protocol"    { type = string }
variable "alb_target_type" { type = string }
variable "vpc_id" {
  description = "VPC ID for ALB and target group"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}


provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

data "aws_vpc" "selected" {
  default = true
}

data "aws_availability_zones" "available" {}

locals {
  private_subnet_cidrs = [
    cidrsubnet(data.aws_vpc.selected.cidr_block, 8, 50),
    cidrsubnet(data.aws_vpc.selected.cidr_block, 8, 51)
  ]
}

module "network" {
  source                = "../../modules/network"
  vpc_id                = data.aws_vpc.selected.id
  private_subnet_cidrs = local.private_subnet_cidrs
  azs                   = data.aws_availability_zones.available.names
  environment           = var.environment
}

module "cluster" {
  source             = "../../modules/cluster"
  cluster_name       = "visitor-${var.environment}"
  cluster_version    = var.cluster_version
  cluster_role_arn   = var.cluster_role_arn 
  private_subnet_ids = module.network.private_subnet_ids
  environment        = var.environment
}

module "nodes" {
  source        = "../../modules/nodes"
  cluster_name  = module.cluster.cluster_name
  node_name     = "private-node-group-${var.environment}"
  subnet_ids    = module.network.private_subnet_ids
  environment   = var.environment
}

resource "aws_lb" "eks_alb" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "eks_tg" {
  name        = "${var.alb_name}-tg"
  port        = var.alb_port
  protocol    = var.alb_protocol
  target_type = var.alb_target_type
  vpc_id      = var.vpc_id
}


resource "aws_security_group" "alb_sg" {
  name        = "${var.alb_name}-sg"
  description = "Allow HTTP to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.alb_name}-sg"
    Environment = var.environment
  }
}
