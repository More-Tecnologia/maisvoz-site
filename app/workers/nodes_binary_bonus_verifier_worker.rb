class NodesBinaryBonusVerifierWorker

  include Sidekiq::Worker

  def perform
    next_run_date = Date.tomorrow.beginning_of_day - 10.minutes
    NodesBinaryBonusVerifierWorker.perform_at(next_run_date)
    run
  end

  private

  def run
    errors = []
    BinaryNode.includes(:user).find_each do |binary_node|
      begin
        ActiveRecord::Base.transaction do
          Bonification::CreatorBinaryBonusService.call(binary_node: binary_node)
        end
      rescue Exception => error
        message = { message: "Binary Bonus Error For #{binary_node.try(:user).try(:username)}: #{error.message}",
                    backtrace: error.backtrace }
        errors << message
      end
    end
    notify_admin_by_email(errors)
  end

  def notify_admin_by_email(errors)
    ErrorsMailer.notify_admin("Binary Bonus Errors: #{errors.size}", errors).deliver_now
  end

end
