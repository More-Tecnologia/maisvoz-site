module Backoffice
  module FinancialTransactionsHelper

    def format_cent_amount_value(financial_transaction)
      amount = financial_transaction.cent_amount
      return number_to_currency(-amount, precision: 2) if financial_transaction.debit?
      number_to_currency(amount, precision: 2)
    end

    def sum_previous_financial_transactions(q, financial_transactions)
      date = financial_transactions.first.created_at
      credit_amount = q.result.credit
                              .where('financial_transactions.created_at <= ?', date)
                              .sum(:cent_amount)
      debit_amount = q.result.debit
                             .where('financial_transactions.created_at <= ?', date)
                             .sum(:cent_amount)
      credit_amount - debit_amount
    end

    def sum_previous_company_financial_transactions(q, financial_transactions)
      date = financial_transactions.first.created_at
      credit_amount = q.result.company_credit
                              .where('financial_transactions.created_at <= ?', date)
                              .sum(:cent_amount)
      debit_amount = q.result.company_debit
                             .where('financial_transactions.created_at <= ?', date)
                             .sum(:cent_amount)
      credit_amount - debit_amount
    end

  end
end
