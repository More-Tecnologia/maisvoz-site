module Backoffice
  module FinancialTransactionsCsvHelper
    def render_transactions_as_csv(transactions)
      text = CSV.generate(col_sep: ';') do |csv|
               csv << csv_headers
               transactions.each do |transaction|
                 csv << financial_transaction_to_csv(transaction)
               end
             end
      send_transactions_to_csv_file(text)
    end

    private

    def csv_headers
      ['hashid',
       FinancialTransaction.human_attribute_name(:financial_reason),
       FinancialTransaction.human_attribute_name(:spreader),
       FinancialTransaction.human_attribute_name(:user),
       t(:deposit),
       FinancialTransaction.human_attribute_name(:cent_amount),
       FinancialTransaction.human_attribute_name(:created_at)]
    end

    def financial_transaction_to_csv(transaction)
      [transaction.hashid,
       transaction.financial_reason.try(:title),
       transaction.spreader.try(:username),
       transaction.user.try(:username),
       transaction.try(:order).try(:hashid),
       transaction.credit? ? transaction.cent_amount : -transaction.cent_amount,
       l(transaction.created_at, format: :long)]
    end

    def send_transactions_to_csv_file(text)
      send_data text, type: 'text/csv',
                      disposition: 'inline',
                      filename: t('defaults.bonus_contracts_csv', datetime: Date.current.to_s)
    end
  end
end
