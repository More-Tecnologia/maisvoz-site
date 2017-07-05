module Financial
  class ApproveWithdrawal

    prepend SimpleCommand

    def initialize(creator, withdrawal)
      @creator = creator
      @withdrawal = withdrawal
      @account = withdrawal.user.account
    end

    def call
      account.lock!

      create_withdraw_financial_entry
      create_fee_entry

      generate_metadata
      debit_account

      financial_entry.save!
    end

    private

    attr_reader :creator, :withdrawal, :account

    def create_withdraw_financial_entry
      financial_entry.from = account
      financial_entry.amount_cents = withdrawal.amount_cents - fee_cents
      financial_entry.kind = FinancialEntry.kinds[:withdrawal]
    end

    def create_fee_entry
      fee_entry = FinancialEntry.new
      fee_entry.from = account
      fee_entry.to = master_financial_account
      fee_entry.amount_cents = fee_cents
      fee_entry.kind = FinancialEntry.kinds[:fee]
      fee_entry.save!
    end

    def generate_metadata
      financial_entry.metadata = FinancialEntryMetadata.new(
        created_by_id: creator.id,
        created_by_username: creator.username,
        origin_account_available_balance_was: account.available_balance
      )
    end

    def debit_account
      account.available_balance_cents -= withdrawal.amount_cents
      account.save!
    end

    def fee_cents
      AppConfig.get(:withdrawal_fee).to_f * withdrawal.amount_cents
    end

    def financial_entry
      @financial_entry ||= FinancialEntry.new
    end

    def master_financial_account
      @master_financial_account ||= Account.find(AppConfig.get(:master_financial_account_id))
    end

  end
end
