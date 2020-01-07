class SupportPointResidualWorker

  include Sidekiq::Worker

  def perform_async
    Bonification::SupportPointResidualService.call
  end

end
