class SlackNotifier
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(message_payload)
    RestClient.post(ENV['SLACK_WEBHOOK_NOTIF_URL'], message_payload.to_json)
  end
end