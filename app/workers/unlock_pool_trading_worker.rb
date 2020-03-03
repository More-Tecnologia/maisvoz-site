class UnlockPoolTradingWorker

  include Sidekiq::Worker

  def perform
    schedule_next_unlock_to_next_sunday
    User.with_blocked_pool_trading.update_all(pool_tranding_blocked_balance: 0)
  end

  private

  def schedule_next_unlock_to_next_sunday
    next_sunday = Date.current.next_occurring(:sunday).end_of_day
    UnlockPoolTradingWorker.perform_at(next_sunday)
  end

end
