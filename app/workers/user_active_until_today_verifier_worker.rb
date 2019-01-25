class UserActiveUntilTodayVerifierWorker

  include Sidekiq::Worker

  def perform(user_id, date)
    user = User.find(user_id)

    Multilevel::VerifyUserStillActive.new(user).call
  end

end
