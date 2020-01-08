class SupportPointResidualWorker

  include Sidekiq::Worker

  def perform
    Bonification::SupportPointResidualService.call
  end

end
