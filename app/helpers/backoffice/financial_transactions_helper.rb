module Backoffice
  module FinancialTransactionsHelper
    def format_cent_amount_value(financial_transaction)
      amount = financial_transaction.cent_amount
      return number_to_currency(-amount) if financial_transaction.debit?
      number_to_currency(amount)
    end

    def find_financial_transactions_search_url
      return backoffice_admin_bonus_financial_transactions_path if controller_is_bonus_financial_transactions?
      return backoffice_admin_financial_transactions_path if controller_path.include?('admin')
      backoffice_financial_transactions_path
    end

    def find_financial_transaction_page_index_title
      return t('defaults.bonus_entries') if controller_is_bonus_financial_transactions?
      t('.title')
    end

    def find financial_reason_types
      return FinancialReasonType.pluck(:name, :id)
    end

    def find_financial_reasons_by_path
      return FinancialReason.bonus.pluck(:title, :id) if controller_is_bonus_financial_transactions?
      FinancialReason.pluck(:title, :id)
    end

    def controller_is_bonus_financial_transactions?
      controller_name == 'bonus_financial_transactions'
    end
  end
end
