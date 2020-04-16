class PoolTradingWorker

  include Sidekiq::Worker

  def perform
    monday_to_friday = (2..6).to_a
    run unless Date.current.wday.in?(monday_to_friday)
    tomorrow_at_end_of_day = Date.tomorrow.end_of_day
    PoolTradingWorker.perform_at(tomorrow_at_end_of_day)
  end

  private

  def run
    errors = []
    commission = rand(ENV['POOL_TRADING_MINIMUM'].to_f..ENV['POOL_TRADING_MAXIMUM'].to_f).round(4)
    User.active.find_each do |user|
      begin
        Bonification::PoolTradingService.call(commission_percent: commission,
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
    ErrorsMailer.notify_admin(subject, errors).deliver_later
  end

end
