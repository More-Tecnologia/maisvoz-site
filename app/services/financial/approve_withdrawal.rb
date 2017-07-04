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

      create_financial_entry
      generate_metadata
      debit_account

      financial_entry.save!
    end

    private

    attr_reader :creator, :withdrawal, :account

    def create_financial_entry
      financial_entry.from = account
      financial_entry.amount_cents = withdrawal.amount_cents
      financial_entry.kind = FinancialEntry.kinds[:withdrawal]
    end

    def generate_metadata
      financial_entry.metadata = FinancialEntryMetadata.new(
        created_by_id: creator.id,
        created_by_username: creator.username,
        origin_account_balance_was: account.balance
      )
    end

    def debit_account
      account.balance_cents -= withdrawal.amount_cents
      account.save!
    end

    def financial_entry
      @financial_entry ||= FinancialEntry.new
    end

  end
end
