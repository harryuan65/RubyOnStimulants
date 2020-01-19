module SlackNotifier
    CLIENT = Slack::Notifier.new ENV["SLACK_WEBHOOK"] do
        defaults channel: "#smallbai"
    end
end