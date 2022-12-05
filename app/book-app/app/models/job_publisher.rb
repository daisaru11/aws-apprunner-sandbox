class JobPublisher
  def publish(job:, payload: nil)
    sns_client.publish(
      topic_arn: ENV['JOB_NOTIFICATION_TOPIC_ARN'],
      message: JSON.dump(
        job: job,
        payload: payload,
        timestamp: Time.zone.now.to_i
      )
    )
  end

  private

  def sns_client
    @sns_client = Aws::SNS::Client.new
  end
end