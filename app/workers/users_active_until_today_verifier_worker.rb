class UsersActiveUntilTodayVerifierWorker

  include Sidekiq::Worker

  def perform
    today = Time.zone.today

    UsersActiveUntilTodayQuery.new(today).find_each do |user|
      UserActiveUntilTodayVerifierWorker.perform_async(user.id, today)
    end
  end

end
