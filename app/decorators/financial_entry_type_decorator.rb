class FinancialEntryTypeDecorator

  def self.status_class(financial_entry)
    type = financial_entry.type
    if type == 'CreditEntry'
      'text-success'
    elsif type == 'DebitEntry'
      'text-danger'
    end
  end

end
