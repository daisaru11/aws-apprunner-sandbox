locals {
  app_services = {
    "api" = {
      role = "api"
    }
    "job" = {
      role = "job"
    }
  }
}
resource "aws_apprunner_service" "app" {
  for_each     = local.app_services
  service_name = "${var.shared_prefix}-book-app-${each.value.role}"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.app_ecr_access.arn
    }
    image_repository {
      image_configuration {
        port = 3000
        runtime_environment_variables = {
          WEB_CONCURRENCY            = 0
          RAILS_MASTER_KEY           = "__insecure_rails_master_key_____"
          DATABASE_URL               = "postgres://book_app:__insecure_db_password__@${aws_rds_cluster.app_db.endpoint}:${aws_rds_cluster.app_db.port}"
          JOB_NOTIFICATION_TOPIC_ARN = aws_sns_topic.job.arn
          ENABLE_OTEL                = 1
          OTEL_PROPAGATORS           = "xray"
        }
      }
      image_identifier      = "${aws_ecr_repository.app.repository_url}:latest"
      image_repository_type = "ECR"
    }

    auto_deployments_enabled = true
  }

  health_check_configuration {
    protocol = "HTTP"
    path     = "/healthz"
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.app.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
  }

  observability_configuration {
    observability_configuration_arn = aws_apprunner_observability_configuration.app.arn
    observability_enabled           = true
  }

  depends_on = [null_resource.app_image]
}

resource "aws_apprunner_observability_configuration" "app" {
  observability_configuration_name = "${var.shared_prefix}-book-app"
  trace_configuration {
    vendor = "AWSXRAY"
  }
}

resource "aws_iam_role" "app_ecr_access" {
  name = "${var.shared_prefix}-book-app-ecr-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_ecr_access" {
  role       = aws_iam_role.app_ecr_access.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role" "app" {
  name = "${var.shared_prefix}-book-app"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


data "aws_iam_policy_document" "app" {
  statement {
    actions = [
      "sns:Publish",
      "sns:ConfirmSubscription",
    ]

    resources = [aws_sns_topic.job.arn]
  }
}

resource "aws_iam_policy" "app" {
  name        = "${var.shared_prefix}-book-app"
  path        = "/"
  description = ""
  policy      = data.aws_iam_policy_document.app.json
}

resource "aws_iam_role_policy_attachment" "app" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.app.arn
}

resource "aws_iam_role_policy_attachment" "app_xray" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
