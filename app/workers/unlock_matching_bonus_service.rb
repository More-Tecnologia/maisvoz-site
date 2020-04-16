class UnlockMatchingBonusService

  include Sidekiq::Worker

  def perform
    schedule_next_unlock_a_week_from_now
    User.with_blocked_mathing_bonus.update_all(blocked_matching_bonus_balance: 0)
  end

  private

  def schedule_next_unlock_a_week_from_now
    a_week_from_now = (Date.current + 1.week).end_of_day
    UnlockMatchingBonusService.perform_at(a_week_from_now)
  end

end
