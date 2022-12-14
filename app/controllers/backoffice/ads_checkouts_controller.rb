# frozen_string_literal: true

module Backoffice
  class AdsCheckoutsController < BackofficeController
    def create
      if valid_params[:payment_method] == 'balance' && current_user.orders.completed.includes(order_items: :product).where(order_items: { products: { kind: :deposit }}).any?
        @order = current_ads_cart
        Payment::BalanceService.call(order: @order)
        clean_ads_cart
        redirect_to backoffice_order_path(@order)
      elsif valid_params[:payment_method] == 'pix'
        @payment_transaction = Payment::Pagstar::PixCheckoutService.call(valid_params)
        ExpireOrderWorker.perform_at(Time.now + 1.hour, valid_params[:order].id)
        clean_ads_cart
        render 'backoffice/payment_transactions/show'
      else
        @payment_transaction = Payment::BlockCheckoutService.call(valid_params)
        ExpireOrderWorker.perform_at(Time.now + 2.hour, valid_params[:order].id)
        clean_ads_cart
        render 'backoffice/payment_transactions/show'
      end
    rescue StandardError => error
      flash[:error] = error.message
      render 'backoffice/ads_carts/show'
    end

    private

    def valid_params
      params.permit(:payment_method)
            .merge(order: current_ads_cart)
    end
  end
end
