resource "aws_ecr_repository" "django" {
  name                 = "${var.project_name}-repo"
  image_tag_mutability = "MUTABLE"
}
