class LastDayAutoWithdrawWorker

  include Sidekiq::Worker

  def perform
    return unless Time.zone.today.end_of_month.today?

    today = Time.zone.now

    User.pf.where(verified: true).where(
      'available_balance_cents > 0 OR blocked_balance_cents > 0'
    ).find_each do |user|
      AutoWithdrawWorker.perform_async(user.id, today)
    end
  end

end
