# frozen_string_literal: true

module Backoffice
  class RafflesCartsController < BackofficeController
    def show
      redirect_to raffles_backoffice_stores_path unless current_raffles_cart.order_items.any?
    end

    def destroy
      current_raffles_cart.order_items.find(params[:order_item_id]).destroy
      Shopping::UpdateCartTotals.call(current_raffles_cart, params[:country])
      flash[:success] = t(:removed_successfully)

      redirect_to backoffice_raffles_carts_path
    end
  end
end
