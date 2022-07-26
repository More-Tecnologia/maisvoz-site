# frozen_string_literal: true

module Backoffice
  class RafflesCartsController < BackofficeController
    def show
      redirect_to raffles_backoffice_stores_path unless current_raffles_cart.order_items.any?
    end

    def destroy
      order_item = current_raffles_cart.order_items.where(id: params[:order_item_id]).first
      if order_item.present?
        order_item.raffle_ticket.update!(order_item_id: nil, status: :available, user_id: nil)
        order_item.destroy
        Shopping::UpdateCartTotals.call(current_raffles_cart, params[:country])
      end
      flash[:success] = t(:removed_successfully)

      redirect_to backoffice_raffles_carts_path
    end
  end
end
