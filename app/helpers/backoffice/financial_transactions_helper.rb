module Backoffice
  module FinancialTransactionsHelper
    def format_cent_amount_value(financial_transaction)
      amount = financial_transaction.cent_amount
      return number_to_currency(-amount) if financial_transaction.debit?
      number_to_currency(amount)
    end
  end
end
