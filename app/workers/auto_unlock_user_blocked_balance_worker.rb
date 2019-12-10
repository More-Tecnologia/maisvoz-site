class AutoUnlockUserBlockedBalanceWorker

  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    Financial::UnlockBlockedBalance.call(user: user)
  end

end
