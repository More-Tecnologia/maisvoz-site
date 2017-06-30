class FinancialEntryTypeDecorator < BaseDecorator

  def initialize(financial_entry)
    @financial_entry = financial_entry
  end

  def kind
    h.content_tag :span do
      I18n.t(financial_entry.kind)
    end
  end

  private

  attr_reader :financial_entry

  def kind_status
    if financial_entry.credit_by_admin?
      'text-success'
    elsif financial_entry.debit_by_admin?
      'text-danger'
    elsif financial_entry.transfer?
      'text-primary'
    end
  end

end
