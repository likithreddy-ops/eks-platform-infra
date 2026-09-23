module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.20"

  role_name             = "ebs-csi-driver"
  attach_ebs_csi_policy = true

  oidc_providers = {
    this = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"
  name               = "platform-eng-cluster"
  kubernetes_version = "1.33"
  enabled_log_types = ["audit", "api", "authenticator"]
  create_cloudwatch_log_group = true
  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  addons = {
    vpc-cni    = {}
    coredns    = {}
    kube-proxy = {}
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
  }

  compute_config = {
    enabled = false
  }

  encryption_config = {
    resources = ["secrets"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = "prod"
  }

  eks_managed_node_groups = {
    node_group1 = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]
      kubernetes_version = "1.33"

      min_size     = 1
      max_size     = 3
      desired_size = 3
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
      }
    }
  }
}
