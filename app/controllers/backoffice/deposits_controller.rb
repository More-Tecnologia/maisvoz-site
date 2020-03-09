# frozen_string_literal: true

module Backoffice
  class DepositsController < EntrepreneurController
    skip_before_action :ensure_admin_or_entrepreneur

    before_action :validate_min_deposit_quantity, only: :create
    before_action :validate_max_deposit_quantity, only: :create

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
      raise Exception unless current_deposit.persisted?

      @payment_transaction = Payment::BlockCheckoutService.call(order: current_deposit)

      render 'backoffice/payment_transactions/show'
    rescue Exception => error
      flash[:error] = error.message
      redirect_to backoffice_cart_path
    end

    private

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

  end
end
