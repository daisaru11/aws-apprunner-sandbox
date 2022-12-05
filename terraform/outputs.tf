output "job_notification_topic_arn" {
  value = aws_sns_topic.job.arn
}

output "job_notification_endpoint" {
  value = "https://${aws_apprunner_service.app["job"].service_url}/jobs"
}
