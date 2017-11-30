module Financial
  class UpdateWithdrawalStatus

    prepend SimpleCommand

    def initialize(creator, params)
      @creator = creator
      @id = params[:id]
      @status = params[:status]
    end

    def call
      if !Withdrawal.statuses.values.include? status
        errors.add(:status, I18n.t('errors.messages.not_found'))
      elsif update_withdrawal
        return withdrawal
      else
        errors.add(:status, 'error')
      end
      nil
    end

    private

    attr_reader :creator, :id, :status

    def update_withdrawal
      ActiveRecord::Base.transaction do
        withdrawal.update!(status: status)
        Financial::ApproveWithdrawal.call(creator, withdrawal) if withdrawal.approved?
      end
    end

    def withdrawal
      @withdrawal ||= Withdrawal.find(id)
    end

  end
end
