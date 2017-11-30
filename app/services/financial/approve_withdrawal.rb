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
      create_fee_entry
      create_system_financial_log

      debit_account

      financial_entry.save!
    end

    private

    attr_reader :creator, :withdrawal, :user

    def create_withdrawal_financial_entry
      financial_entry.user         = user
      financial_entry.description  = "Correspondente ao saque ID: #{withdrawal.id}"
      financial_entry.amount_cents = -withdrawal.net_amount_cents
      fee_entry.balance_cents      = user.available_balance_cents - withdrawal.net_amount_cents
      financial_entry.kind         = FinancialEntry.kinds[:withdrawal]
    end

    def create_fee_entry
      fee_entry               = FinancialEntry.new
      fee_entry.description   = "Correspondente ao saque ID: #{withdrawal.id}"
      fee_entry.user          = user
      fee_entry.amount_cents  = -fee_cents
      fee_entry.balance_cents = user.available_balance_cents - fee_cents
      fee_entry.kind          = FinancialEntry.kinds[:fee]
      fee_entry.save!
    end

    def create_system_financial_log
      system_log              = SystemFinancialLog.new
      system_log.description  = "Comissão sobre saque ID: #{withdrawal.id} de $#{withdrawal.gross_amount}"
      system_log.amount_cents = fee_cents
      system_log.kind         = SystemFinancialLog.kinds[:fee]
      system_log.save!
    end

    def debit_account
      user.decrement!(:available_balance_cents, withdrawal.gross_amount_cents)
    end

    def fee_cents
      @fee_cents ||= AppConfig.get(:withdrawal_fee).to_f * withdrawal.gross_amount_cents
    end

    def financial_entry
      @financial_entry ||= FinancialEntry.new
    end

  end
end
