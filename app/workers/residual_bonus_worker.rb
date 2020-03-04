class ResidualBonusWorker

  include Sidekiq::Worker

  def perform
    schedule_next_perform_at_a_month
    Bonification::CreatorResidualBonusService.call
  end

  private

  def schedule_next_perform_at_a_month
    next_beginning_of_month = 1.month.from_now.beginning_of_month
    ResidualBonusWorker.perform_at(next_beginning_of_month)
  end

end
