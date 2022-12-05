resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "${var.shared_prefix}-connector"
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.vpc_connector.id]
}

resource "aws_security_group" "vpc_connector" {
  name        = "${var.shared_prefix}-apprunner-vpc-connector"
  description = "${var.shared_prefix}-apprunner-vpc-connector"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

