class AutoWithdrawWorker

  include Sidekiq::Worker

  def perform(user_id, today)
    user = User.find(user_id)
    Financial::AutoWithdrawService.new(user, today).call
  end

end
