output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.django.repository_url
}

output "db_endpoint" {
  value = aws_db_instance.postgres.address
}
