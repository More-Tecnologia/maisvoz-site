# frozen_string_literal: true

module Backoffice
  class RaffleThirdPartiesCartsController < BackofficeController
    def show
      redirect root_path unless ApplicationController.helpers.package_buyer?(current_user)

      @order = Order.joins(:products)
                    .pending_payment
                    .where.not(user: current_user)
                    .where(products: { id: Product.raffle })
                    .find_by_hashid(params[:hashid])

      if @order.nil? && params[:hashid].present?
        flash[:error] = t(:raffle_order_not_found)
      end
    end
  end
end
