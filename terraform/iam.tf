#module "eks_irsa" {
#  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#  version = "5.39.0"
#
#  role_name = "${var.project_name}-cluster-role"
#  attach_load_balancer_controller_policy = true
#
#  oidc_providers = {
#    eks = {
#      provider_arn = module.eks.oidc_provider_arn
#    }
#  }
#}
