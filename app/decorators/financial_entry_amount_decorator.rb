class FinancialEntryAmountDecorator < BaseDecorator

  def initialize(financial_entry, user)
    @financial_entry = financial_entry
    @user = user
  end

  def amount
    h.content_tag :span, class: style_class do
      h.number_to_currency financial_entry.amount
    end
  end

  private

  attr_reader :financial_entry, :user

  def style_class
    return 'text-success' if financial_entry.amount_cents > 0
    'text-danger'
  end

end
