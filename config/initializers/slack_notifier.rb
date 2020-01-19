module SlackNotifier
    CLIENT = Slack::Notifier.new "https://hooks.slack.com/services/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" do
        defaults channel: "#smallbai"
    end
end