module Financial
  class AutoWithdrawService

    def initialize(user, ref_date)
      @user = user
      @ref_date = DateTime.parse(ref_date)
    end

    def call
      return if user.pj? || user.blocked_balance == 0

      ActiveRecord::Base.transaction do
        create_tax_entry
        debit_tax_from_blocked_balance
        create_withdraw
        zero_account
      end
    end

    private

    attr_reader :user, :ref_date

    def create_tax_entry
      return if tax_amount_cents.zero?
      FinancialEntry.new.tap do |entry|
        entry.user          = user
        entry.description   = "Taxa de IRPF sobre #{h.number_to_currency (amount_received_cents / 1e2)}"
        entry.kind          = FinancialEntry.kinds[:tax]
        entry.amount_cents  = -tax_amount_cents
        entry.balance_cents = user.balance_cents - tax_amount_cents
        entry.save!
      end
    end

    def debit_tax_from_blocked_balance
      user.decrement!(:blocked_balance_cents, tax_amount_cents)
    end

    def create_withdraw
      Withdrawal.new.tap do |withdrawal|
        withdrawal.user         = user
        withdrawal.status       = Withdrawal.statuses[:pending]
        withdrawal.gross_amount = user.balance
        withdrawal.net_amount   = user.balance - fee
        withdrawal.save!
      end
    end

    def zero_account
      user.available_balance_cents = 0
      user.blocked_balance_cents   = 0
      user.save!
    end

    def tax_amount_cents
      @tax_amount_cents ||= Tax::IRPFCalculatorService.new(amount_received_cents).call
    end

    def amount_received_cents
      @amount_received_cents ||= UserBalanceByMonthQuery.new(user, ref_date).call
    end

    def amount_to_withdraw
      user.available_balance_cents + user.b
    end

    def fee
      ENV['WITHDRAWAL_FEE'].to_d
    end

    def h
      ActionController::Base.helpers
    end

  end
end
