module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.13.0"

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true
  manage_aws_auth = true  # module writes aws-auth configmap

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_endpoint_public_access_cidrs = ["122.177.241.85/32"]

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 1
      max_size       = 2
      min_size       = 1
      subnet_ids     = module.vpc.private_subnets 
    }
  }

  spot = {
      desired_capacity = 2
      max_capacity     = 5
      min_capacity     = 0
      instance_types   = ["t3.small","t3.medium"]
      capacity_type    = "SPOT"
      tags = {
        "lifecycle" = "spot"
      }
      # labels can be used by pod/node selectors
      labels = {
        "node.kubernetes.io/lifecycle" = "spot"
      }
  }
}
