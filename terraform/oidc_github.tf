#data "aws_caller_identity" "current" {}
#
#resource "aws_iam_openid_connect_provider" "github" {
#  url             = "https://token.actions.githubusercontent.com"
#  client_id_list  = ["sts.amazonaws.com"]
#  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub's thumbprint
#}
#
## Role trust — limit sub to your repo/branch for safety (replace org/repo)
#locals {
#  repo_sub = "repo:vicky-s-cloud-projects/3-tier-application:ref:refs/heads/main"
#}
#
#resource "aws_iam_role" "github_actions" {
#  name = "${var.project_name}-github-actions-role"
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [{
#      Effect    = "Allow"
#      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
#      Action    = "sts:AssumeRoleWithWebIdentity"
#      Condition = {
#        StringEquals = {
#          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
#          "token.actions.githubusercontent.com:sub" = local.repo_sub
#        }
#      }
#    }]
#  })
#}
#
## Attached policy: ECR push, EKS describe, STS assume
#resource "aws_iam_policy" "github_deploy_policy" {
#  name = "${var.project_name}-github-actions-policy"
#  policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [
#      {
#        Effect = "Allow",
#        Action = [
#          "ecr:GetAuthorizationToken",
#          "ecr:BatchCheckLayerAvailability",
#          "ecr:CompleteLayerUpload",
#          "ecr:UploadLayerPart",
#          "ecr:InitiateLayerUpload",
#          "ecr:PutImage",
#          "ecr:DescribeRepositories",
#          "ecr:CreateRepository"
#        ],
#        Resource = "*"
#      },
#      {
#        Effect = "Allow",
#        Action = [
#          "eks:DescribeCluster",
#          "eks:ListClusters"
#        ],
#        Resource = "*"
#      },
#      {
#        Effect = "Allow",
#        Action = [
#          "sts:AssumeRole"
#        ],
#        Resource = "*"
#      },
#      {
#        Effect = "Allow",
#        Action = [
#          "s3:GetObject",
#          "s3:ListBucket"
#        ],
#        Resource = "*"
#      }
#    ]
#  })
#}
#
#resource "aws_iam_role_policy_attachment" "attach_github_policy" {
#  role       = aws_iam_role.github_actions.name
#  policy_arn = aws_iam_policy.github_deploy_policy.arn
#}
#