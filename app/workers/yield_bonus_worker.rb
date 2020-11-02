class YieldBonusWorker
  include Sidekiq::Worker

  def perform
    thursday_to_saturday = (2..6).to_a
    Bonification::CreatorYieldService.call if Date.current.wday.in?(thursday_to_saturday)

    YieldBonusWorker.perform_at(Date.tomorrow.beginning_of_day)
  end
end
