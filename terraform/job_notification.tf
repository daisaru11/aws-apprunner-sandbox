resource "aws_sns_topic" "job" {
  name = "${var.shared_prefix}-book-app-job"
}
