# frozen_string_literal: true

module Backoffice
  class DepositsController < EntrepreneurController
    include Backoffice::OrdersHelper

    before_action :validate_deposit_value, only: :create

    def index
      @deposits = OrderItem.includes(order: :payment_transaction)
                           .where(product: Product.deposit, order: current_user.orders.not_cart)
                           .order(created_at: :desc)
                           .map(&:order)
    end

    def new; end

    def cart; end

    def create
      current_deposit.order_items.first.update(valid_params)
      Shopping::UpdateCartTotals.call(current_deposit)

      redirect_to cart_backoffice_deposits_path
    end

    def checkout
      @payment_transaction = Payment::Coinbase::ChargesService.call(order: current_deposit)
      render 'backoffice/payment_transactions/show'
    rescue StandardError => error
      flash[:error] = error.message
      redirect_to backoffice_cart_path
    end

    private

    def validate_deposit_value
      item_quantity = params[:order_item][:quantity].to_f if params[:order_item]
      deposit_value = [item_quantity, current_deposit.total_value].max

      return if deposit_value >= minimum_deposit_value

      flash[:alert] = t('defaults.errors.invalid_deposit_value')
      redirect_to new_backoffice_deposit_path
    end

    def validate_max_deposit_quantity
      return if valid_params[:quantity].to_i <= ENV['MAX_DEPOSIT'].to_i

      flash[:error] = t(:max_deposit, limit: ENV['MAX_DEPOSIT'])
      redirect_to new_backoffice_deposit_path
    end

    def validate_min_deposit_quantity
      return if valid_params[:quantity].to_i >= ENV['MIN_DEPOSIT'].to_i

      flash[:error] = t(:min_deposit, limit: ENV['MIN_DEPOSIT'])
      redirect_to new_backoffice_deposit_path
    end

    def valid_params
      params.require(:order_item).permit(:quantity)
    end

    def validate_user_active_loan_contract
      return unless current_user.current_loan_contract

      flash[:error] = t('there_are_loan_contract_active')
      redirect_to new_backoffice_deposit_path
    end
  end
end
