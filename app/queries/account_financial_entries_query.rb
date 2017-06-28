class AccountFinancialEntriesQuery

  def initialize(account, relation = FinancialEntry.all)
    @financial_entries = relation
    @account = account
  end

  def call
    financial_entries.where(
      to: account
    ).or(
      financial_entries.where(from: account)
    ).order(created_at: :desc)
  end

  private

  attr_reader :financial_entries, :account

end
