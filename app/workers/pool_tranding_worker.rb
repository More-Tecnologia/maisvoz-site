class PoolTrandingWorker

  include Sidekiq::Worker

  def perform
    User.active.find_each do |user|
      begin
        Bonification::PoolTrandingService.call(commission_percent: PoolTranding.current_pool_tranding,
                                               user: user)
      rescue Exception => error
        puts "Error while create Pool Tranding for #{user.username}: #{error.message}"
        puts error.backtrace
      end
    end
  end

end
