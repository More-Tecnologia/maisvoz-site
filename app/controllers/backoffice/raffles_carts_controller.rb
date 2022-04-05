# frozen_string_literal: true

module Backoffice
  class RafflesCartsController < BackofficeController
    def show
      redirect_to raffles_backoffice_stores_path unless current_raffles_cart.order_items.any?
    end

    def destroy
      order_item = current_raffles_cart.order_items.find(params[:order_item_id])
      order_item.raffle_ticket.update!(order_item_id: nil, status: :available, user_id: nil)
      order_item.destroy
      Shopping::UpdateCartTotals.call(current_raffles_cart, params[:country])
      flash[:success] = t(:removed_successfully)

      redirect_to backoffice_raffles_carts_path
    end
  end
end
