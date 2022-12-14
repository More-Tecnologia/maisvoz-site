module Backoffice
  module FinancialTransactionsHelper

    def find_financial_transactions_by_current_user(q)
      return @financial_transactions ||= financial_transactions_by_morenwm(q) if current_user.morenwm_user?
      return @financial_transactions ||= financial_transactions_by_customer_admin(q) if current_user.customer_admin?
      return @financial_transactions ||= financial_transactions_by_empreendedor(q) if current_user.empreendedor?
      []
    end

    def financial_transactions_by_morenwm(q)
      q.result.by_current_user(current_user)
              .to_morenwm
              .includes(:user, :spreader, :financial_reason, :order)
              .order(created_at: :desc)
              .page(params[:page])
              .per(10)
    end

    def financial_transactions_by_customer_admin(q)
      q.result.to_customer_admin
              .includes(:user, :spreader, :financial_reason, :order)
              .order(created_at: :desc)
              .page(params[:page])
              .per(10)
    end

    def financial_transactions_by_empreendedor(q)
      q.result.by_current_user(current_user)
              .to_empreendedor
              .includes(:spreader, :financial_reason, :order)
              .order(created_at: :desc)
              .page(params[:page])
              .per(10)
    end

    def format_cent_amount_value(financial_transaction)
      amount = financial_transaction.cent_amount
      return number_to_currency(-amount, precision: 2) if financial_transaction.debit?
      number_to_currency(amount, precision: 2)
    end

    def sum_previous_financial_transactions_by_morenwm(q)
      date = find_first_financial_transaction_created_at_from_query(q)
      return 0 unless date
      credit_amount = q.result.by_current_user(current_user)
                              .to_morenwm
                              .morenwm_moneyflow_credit
                              .backward_at(date)
                              .sum(:cent_amount)
      debit_amount = q.result.by_current_user(current_user)
                             .to_morenwm
                             .morenwm_moneyflow_debit
                             .backward_at(date)
                             .sum(:cent_amount)
      (credit_amount - debit_amount).abs / 1e8.to_f
    end

    def sum_previous_financial_transactions_by_customer_admin(q)
      date = find_first_financial_transaction_created_at_from_query(q)
      return 0 unless date
      credit_amount = q.result.to_customer_admin
                              .company_credit
                              .backward_at(date)
                              .sum(:cent_amount)
      debit_amount = q.result.to_customer_admin
                             .company_debit
                             .backward_at(date)
                             .sum(:cent_amount)
      (credit_amount - debit_amount) / 1e8.to_f
    end

    def sum_previous_financial_transactions_by_empreendedor(q)
      date = find_first_financial_transaction_created_at_from_query(q)
      return 0 unless date
      credit_amount = q.result.by_current_user(current_user)
                              .to_empreendedor
                              .credit
                              .backward_at(date)
                              .sum(:cent_amount)
      debit_amount = q.result.by_current_user(current_user)
                             .to_empreendedor
                             .debit
                             .backward_at(date)
                             .sum(:cent_amount)
      (credit_amount - debit_amount) / 1e8.to_f
    end

    def find_first_financial_transaction_created_at_from_query(q)
      financial_transactions = find_financial_transactions_by_current_user(q)
      financial_transactions.first.try(:created_at)
    end

    def detect_financial_reasons_by_current_user
      return FinancialReason.active.to_morenwm.order(:title).pluck(:title, :id) if current_user.morenwm_user?
      return FinancialReason.active.to_customer_admin.order(:title).pluck(:title, :id) if current_user.customer_admin?
      return FinancialReason.active.to_empreendedor.order(:title).pluck(:title, :id) if current_user.empreendedor?
      []
    end

    def format_financial_reason(transaction)
      reason = transaction.try(:financial_reason)
      label = reason.try(:title)
      return "#{label} | #{transaction.note}" if reason.credit_reason? || reason.debit_reason? || reason.expense_reason? || reason.pool_wallet_expense_reason?
      label
    end

    def format_financial_transaction_by_morenwm_user(transaction)
      return number_to_currency(transaction.cent_amount) if transaction.financial_reason.morenwm_moneyflow_credit?
      return number_to_currency(-transaction.cent_amount) if transaction.financial_reason.morenwm_moneyflow_debit?
      ''
    end
    
    def change_color_on_debit_transaction(financial_transaction)
      return 'text-danger' if financial_transaction.debit? && current_user != User.find_morenwm_user            
    end

  end
end
