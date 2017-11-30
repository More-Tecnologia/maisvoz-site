class AccountFinancialEntriesQuery

  def initialize(user, relation = FinancialEntry.all)
    @financial_entries = relation
    @user = user
  end

  def call
    financial_entries.where(
      user: user
    ).order(created_at: :desc)
  end

  private

  attr_reader :financial_entries, :user

end
