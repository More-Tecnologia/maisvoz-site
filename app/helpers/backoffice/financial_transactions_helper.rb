module Backoffice
  module FinancialTransactionsHelper

    def format_cent_amount_value(financial_transaction)
      amount = financial_transaction.cent_amount
      return number_to_currency(-amount, precision: 8) if financial_transaction.debit?
      number_to_currency(amount, precision: 8)
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
      return FinancialReason.bonus.unilevel.order(:title).pluck(:title, :id) if controller_is_bonus_financial_transactions?
      return FinancialReason.pluck(:title, :id) if current_user.admin?
      FinancialReason.where.not(id: FinancialReason.morenwm_fee.id).pluck(:title, :id)
    end

    def controller_is_bonus_financial_transactions?
      controller_name == 'bonus_financial_transactions'
    end

    def sum_previous_financial_transactions(q, financial_transactions)
      date = financial_transactions.first.created_at
      credit_amount = q.result().credit
                                .where('created_at <= ?', date)
                                .sum(:cent_amount)
      debit_amount = q.result().debit
                               .where('created_at <= ?', date)
                               .sum(:cent_amount)
      credit_amount - debit_amount
    end

  end
end
