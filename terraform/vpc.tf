module "vpc" {
  #Modulo que o terraform nos fornece para criar a VPC  
  source = "terraform-aws-modules/vpc/aws"

  name = "minha-vpc" #Nome da VPC
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway = true
  map_public_ip_on_launch = true

# TAGS para que o eks saiba qual subnet ele vai gerenciar
  private_subnet_tags = {
    name = format("%s-sub-private", var.eks_name),
    "kubernetes.io/role/internal-elb" = "1",
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }

  public_subnet_tags = {
    "Name" = format("%s-sub-public", var.eks_name),
    "kubernetes.io/role/elb" = "1",
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }
}