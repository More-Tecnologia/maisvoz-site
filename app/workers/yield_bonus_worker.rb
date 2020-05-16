class YieldBonusWorker

  include Sidekiq::Worker

  def perform
    Bonification::CreatorYieldService.call
    schedule_next_perform_in_one_day
  end

  private

  def schedule_next_perform_in_one_day
    next_beginning_of_day = 1.day.from_now.beginning_of_day
    YieldBonusWorker.perform_at(next_beginning_of_day)
  end

end
