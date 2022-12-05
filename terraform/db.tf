resource "aws_db_subnet_group" "app_db" {
  name       = "${var.shared_prefix}-book-app-db"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "app_db" {
  name        = "${var.shared_prefix}-book-app-db"
  description = "${var.shared_prefix}-book-app-db"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_connector.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "app_db" {
  cluster_identifier     = "${var.shared_prefix}-app-db"
  engine                 = "aurora-postgresql"
  engine_version         = "14.3"
  engine_mode            = "provisioned"
  availability_zones     = var.aws_azs
  database_name          = "book_app"
  master_username        = "book_app"
  master_password        = "__insecure_db_password__"
  port                   = 5432
  vpc_security_group_ids = [aws_security_group.app_db.id]
  db_subnet_group_name   = aws_db_subnet_group.app_db.name
  skip_final_snapshot    = true

  serverlessv2_scaling_configuration {
    max_capacity = 1
    min_capacity = 0.5
  }
}

resource "aws_rds_cluster_instance" "app_db" {
  count              = 1
  cluster_identifier = aws_rds_cluster.app_db.id
  identifier         = "${var.shared_prefix}-app-db-${count.index}"

  engine               = aws_rds_cluster.app_db.engine
  engine_version       = aws_rds_cluster.app_db.engine_version
  instance_class       = "db.serverless"
  db_subnet_group_name = aws_rds_cluster.app_db.db_subnet_group_name
}
