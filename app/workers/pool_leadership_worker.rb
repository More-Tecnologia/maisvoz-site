class PoolLeadershipWorker

  include Sidekiq::Worker

  def perform
    next_run_date = Date.today.at_beginning_of_month.next_month + 22.hours
    PoolTrandingWorker.perform_at(next_run_date)
    run
  end

  private

  def run
    errors = []
    users_ids.each do |user_id|
      begin
        Bonification::PoolLeadershipService.call(user_id: user_id)
      rescue Exception => error
        error = {
          message: "Error while create Pool Leadership for #{user.username}: #{error.message}",
          backtrace: error.backtrace }
        errors << error
      end
    end
    notify_admin_by_email(errors)
  end

  def notify_admin_by_email(errors)
    subject = "Pool Leadership Errors: #{errors.size}"
    ErrorsMailer.notify_admin(subject, errors).deliver_now
  end

  def users_ids
    CareerTrailUser.select('user_id')
                   .joins(career_trail: :career)
                   .where(career_trails: { careers: { name: 'Chairman' } })
                   .map(&:user_id)
                   .uniq
  end

end
