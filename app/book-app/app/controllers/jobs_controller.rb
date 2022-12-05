class JobsController < ApplicationController
  before_action :verify_request_authenticity

  def create
    case message_body['Type']
    when 'SubscriptionConfirmation'
      confirm_subscription ? (head :ok) : (head :bad_request)
    when 'Notification'
      message = JSON.parse(message_body['Message'])
      JobRunner.new.execute(job: message['job'], payload: message['payload'])
      head :ok
    end
  end

  private

  def verify_request_authenticity
    head :unauthorized if raw_post.blank? || !message_verifier.authentic?(raw_post)
  end

  def raw_post
    @raw_post ||= request.raw_post
  end

  def message_body
    @message_body ||= JSON.parse(raw_post)
  end

  def message_verifier
    @message_verifier ||= Aws::SNS::MessageVerifier.new
  end

  def sns_client
    @sns_client = Aws::SNS::Client.new
  end

  def confirm_subscription
    sns_client.confirm_subscription(
      topic_arn: message_body['TopicArn'],
      token: message_body['Token']
    )
    true
  rescue Aws::SNS::Errors::ServiceError => e
    Rails.logger.error(e.message)
    false
  end
end