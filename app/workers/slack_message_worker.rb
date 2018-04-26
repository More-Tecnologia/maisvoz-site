class SlackMessageWorker
  include Sidekiq::Worker

  def perform(channel, message)
    token = ENV.fetch('SLACK_API_TOKEN', false)
    return if token.blank?
    client = Slack::Web::Client.new(token: token)
    client.chat_postMessage(channel: channel, text: message)
  end

end
