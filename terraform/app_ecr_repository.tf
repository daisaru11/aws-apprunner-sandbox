resource "aws_ecr_repository" "app" {
  name         = "${var.shared_prefix}/book-app"
  force_delete = true # WARN
}
