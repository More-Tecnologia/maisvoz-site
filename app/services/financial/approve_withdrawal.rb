module Financial
  class ApproveWithdrawal

    prepend SimpleCommand

    def initialize(creator, withdrawal)
      @creator = creator
      @withdrawal = withdrawal
      @user = withdrawal.user
    end

    def call
      user.lock!

      create_withdrawal_financial_entry
      create_withdraw_fee
      send_notification

      financial_entry.save!
    end

    private

    attr_reader :creator, :withdrawal, :user

    def create_withdrawal_financial_entry
      financial_entry.user        = user
      financial_entry.description = "Correspondente ao saque ID: #{withdrawal.id}"
      financial_entry.amount      = -withdrawal.gross_amount
      financial_entry.balance     = user.balance
      financial_entry.kind        = FinancialEntry.kinds[:withdrawal]
    end

    def create_withdraw_fee
      Fee::CreateWithdrawFee.new(withdrawal, fee).call
    end

    def send_notification
      WithdrawalsMailer.with(withdrawal: withdrawal).approved.deliver_later
    end

    def fee
      @fee ||= ENV['WITHDRAWAL_FEE'].to_f
    end

    def financial_entry
      @financial_entry ||= FinancialEntry.new
    end

  end
end
