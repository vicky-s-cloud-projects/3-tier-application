terraform {
  backend "s3" {
    bucket         = "tfstate-django-ecom-138973099853"
    key            = "global/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tfstate-locks-django-ecom"
    encrypt        = true
  }
}
