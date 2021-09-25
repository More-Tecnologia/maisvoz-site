class RecurrentCreatorWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    Bonification::RecurrentCreatorService.call(user: user)
  end
end
