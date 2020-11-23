class WakeWorker
  include Sidekiq::Worker
  def perform
    puts RestClient.get(ENV['HOST_WAKE_UP_PATH']).code
  end
end