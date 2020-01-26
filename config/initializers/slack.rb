Slack.configure do |config|
    config.token = ENV['SLACK_API_KEY']
    raise 'Missing ENV["SLACK_API_KEY"]!' unless config.token
end
$client = Slack::Web::Client.new