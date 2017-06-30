class FinancialEntryAmountDecorator < BaseDecorator

  def initialize(financial_entry, user)
    @financial_entry = financial_entry
    @account = user.account
  end

  def amount
    h.content_tag :span, class: style_class do
      h.number_to_currency financial_entry.amount
    end
  end

  private

  attr_reader :financial_entry, :account

  def style_class
    return 'text-success' if financial_entry.to == account
    'text-danger'
  end

end
