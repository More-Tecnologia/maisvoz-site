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
      create_system_financial_log

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

    def create_system_financial_log
      system_log             = SystemFinancialLog.new
      system_log.description = "Taxa sobre saque ID: #{withdrawal.id} de R$#{withdrawal.gross_amount}"
      system_log.amount      = fee
      system_log.kind        = SystemFinancialLog.kinds[:fee]
      system_log.save!
    end

    def fee
      @fee ||= AppConfig.get(:withdrawal_fee).to_f
    end

    def financial_entry
      @financial_entry ||= FinancialEntry.new
    end

  end
end
