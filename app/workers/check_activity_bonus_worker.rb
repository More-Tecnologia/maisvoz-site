class CheckActivityBonusWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    Bonification::CreditActivityBonus.new(user).call
  end

end
