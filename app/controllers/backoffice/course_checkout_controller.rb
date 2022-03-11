# frozen_string_literal: true

module Backoffice
  module Admin
    class CourseCheckoutController < ApplicationController
      def checkout
        @payment_transaction = Payment::BlockCheckoutService.call(valid_params)
        ExpireOrderWorker.perform_at(Time.now + 5.hour, valid_params[:order].id)
        clean_courses_cart
        render 'backoffice/payment_transactions/show'
      rescue StandardError => error
        flash[:error] = error.message
        render :show
      end
    end

    private

    def valid_params
      params.permit(:payment_method)
            .merge(order: current_courses_cart)
    end
  end
end
