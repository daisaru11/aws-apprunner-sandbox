resource "null_resource" "app_image" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command     = "./deploy_image.sh"
    working_dir = "${path.module}/../app/book-app/"
    environment = {
      AWS_REGION     = data.aws_region.current.name
      AWS_ACCOUNT_ID = data.aws_caller_identity.current.id
      REPO_URL       = aws_ecr_repository.app.repository_url
    }
  }
}
