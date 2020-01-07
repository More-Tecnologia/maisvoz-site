module Backoffice
  module FinancialTransactionsHelper

    def find_financial_transactions_by_current_user(q)
      return @financial_transactions ||= find_financial_transactions_by_morenwm(q) if current_user.morenwm_user?
      return @financial_transactions ||= find_financial_transactions_by_customer_admin(q) if current_user.customer_admin?
      return @financial_transactions ||= find_financial_transactions_by_empreendedor(q) if current_user.empreendedor?
      []
    end

    def find_financial_transactions_by_morenwm(q)
      q.result
       .where(user: current_user)
       .joins(:financial_reason)
       .merge(FinancialReason.to_morenwm)
       .includes(:user, :spreader, :financial_reason, :order)
       .order(created_at: :desc)
       .page(params[:page])
    end

    def find_financial_transactions_by_customer_admin(q)
      q.result
       .joins(:financial_reason)
       .merge(FinancialReason.to_customer_admin)
       .includes(:user, :spreader, :financial_reason, :order)
       .order(created_at: :desc)
       .page(params[:page])
    end

    def find_financial_transactions_by_empreendedor(q)
      q.result
       .where(user: current_user)
       .joins(:financial_reason)
       .merge(FinancialReason.to_empreendedor)
       .includes(:spreader, :financial_reason, :order)
       .order(created_at: :desc)
       .page(params[:page])
    end

    def format_cent_amount_value(financial_transaction)
      amount = financial_transaction.cent_amount
      return number_to_currency(-amount, precision: 2) if financial_transaction.debit?
      number_to_currency(amount, precision: 2)
    end

    def sum_previous_financial_transactions(q)
      financial_transactions ||= find_financial_transactions_by_current_user(q)
      date = financial_transactions.first.try(:created_at)
      return 0 unless date
      credit_amount = financial_transactions.credit
                                            .backward_at(date)
                                            .sum(:cent_amount)
      debit_amount = financial_transactions.debit
                                           .backward_at(date)
                                           .sum(:cent_amount)
      amount = (credit_amount - debit_amount).abs / 1e8.to_f
      update_user_available_balance_cents(amount)
      amount
    end

    def sum_previous_company_financial_transactions(q)
      financial_transactions = find_financial_transactions_by_current_user(q)
      date = financial_transactions.first.try(:created_at)
      return 0 unless date
      credit_amount = financial_transactions.company_credit
                                            .backward_at(date)
                                            .sum(:cent_amount)
      debit_amount = financial_transactions.company_debit
                                           .backward_at(date)
                                           .sum(:cent_amount)
      amount = (credit_amount - debit_amount).abs / 1e8.to_f
      update_user_available_balance_cents(amount)
      amount
    end

    def update_user_available_balance_cents(amount)
      return if amount == current_user.available_balance_cents
      current_user.update_attributes(available_balance_cents: amount)
    end

    def detect_financial_reasons_by_current_user
      return FinancialReason.active.to_morenwm.order(:title).pluck(:title, :id) if current_user.morenwm_user?
      return FinancialReason.active.to_customer_admin.order(:title).pluck(:title, :id) if current_user.customer_admin?
      return FinancialReason.active.to_empreendedor.order(:title).pluck(:title, :id) if current_user.empreendedor?
      []
    end

  end
end
