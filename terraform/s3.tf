resource "aws_s3_bucket" "static" {
  bucket = "${var.project_name}-static-${random_id.rand.hex}"
}

resource "random_id" "rand" {
  byte_length = 4
}
