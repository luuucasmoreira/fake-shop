module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.eks_name
  cluster_version = var.eks_version
  subnet_ids      = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id
  cluster_endpoint_private_access = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    live = {
      name = "live"
      desired_capacity = 2
      max_size         = 4
      min_size         = 2
      instance_type    = "t3.medium"
    }
  }

  tags = {
    owner = "lucas-terraform"
  }
}