terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"   # usa rama 5.x estable
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "todo-api-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = "todo-api-cluster"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  eks_managed_node_groups = {
    default = {
      min_size       = 0
      max_size       = 4
      desired_size   = 3
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  # Declarar el access entry para el usuario bootstrap
  access_entries = {
    bootstrapuser = {
      principal_arn = "arn:aws:iam::125466162245:user/bootstrapuser"
      policies = [
        "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      ]
      type = "STANDARD"
    }
  }
}

# CloudWatch Container Insights (addon)
resource "aws_eks_addon" "cloudwatch" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "amazon-cloudwatch-observability"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [module.eks]
}

# S3 bucket opcional
#resource "aws_s3_bucket" "logs" {
#  bucket = "todo-api-logs-us-east-1"
#}

#attachar access policy
resource "null_resource" "associate_access_policy" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = "aws eks associate-access-policy --cluster-name todo-api-cluster --principal-arn arn:aws:iam::125466162245:user/bootstrapuser --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy --access-scope type=cluster --region us-east-1"
  }
}