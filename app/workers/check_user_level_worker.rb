class CheckUserLevelWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    LevelUp::CheckUser.new(user).call
  end

end
