# frozen_string_literal: true

module Backoffice
  class CourseCheckoutsController < BackofficeController
    def create
      if valid_params[:payment_method] == 'balance'
        @order = current_courses_cart
        Payment::BalanceService.call(order: @order)
        clean_courses_cart
        redirect_to backoffice_order_path(@order)
      elsif valid_params[:payment_method] == 'pix'
        @payment_transaction = Payment::Pagstar::PixCheckoutService.call(valid_params)
        ExpireOrderWorker.perform_at(Time.now + 1.hour, valid_params[:order].id)
        clean_courses_cart
        render 'backoffice/payment_transactions/show'
      else
        @payment_transaction = Payment::BlockCheckoutService.call(valid_params)
        ExpireOrderWorker.perform_at(Time.now + 5.hour, valid_params[:order].id)
        clean_courses_cart
        render 'backoffice/payment_transactions/show'
      end
    rescue StandardError => error
      flash[:error] = error.message
      render 'backoffice/courses_carts/show'
    end

    private

    def valid_params
      params.permit(:payment_method)
            .merge(order: current_courses_cart)
    end
  end
end
