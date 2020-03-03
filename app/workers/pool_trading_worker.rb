class PoolTradingWorker

  include Sidekiq::Worker

  def perform
    next_run_date = Date.tomorrow.beginning_of_day + 20.minutes
    PoolTradingWorker.perform_at(next_run_date)
    run
  end

  private

  def run
    errors = []
    User.active.find_each do |user|
      begin
        Bonification::PoolTrandingService.call(commission_percent: PoolTranding.current_pool_tranding,
                                               user: user)
      rescue Exception => error
        error = { message: "Error while create Trading Bonus for #{user.username}: #{error.message}",
                  backtrace: error.backtrace }
        errors <<  error
      end
    end
    notify_admin_by_email(errors)
  end

  def notify_admin_by_email(errors)
    subject = "Pool Tranding Errors: #{errors.size}"
    ErrorsMailer.notify_admin(subject, errors).deliver_now
  end

end
