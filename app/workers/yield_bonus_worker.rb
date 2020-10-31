class YieldBonusWorker
  include Sidekiq::Worker

  def perform
    monday_to_friday = (1..5).to_a
    Bonification::CreatorYieldService.call if Date.current.wday.in?(monday_to_friday)

    YieldBonusWorker.perform_at(Date.tomorrow.beginning_of_day)
  end
end
