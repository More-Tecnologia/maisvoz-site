class AutoUnlockUsersBlockedBalanceWorker

  include Sidekiq::Worker

  def perform
    User.where.not(
      blocked_balance_cents: 0
    ).where(
      "balance_unlocked_at >= ?", 20.days.ago
    ).find_each do |user|
      AutoUnlockUserBlockedBalanceWorker.perform_async(user.id)
    end
  end

end
