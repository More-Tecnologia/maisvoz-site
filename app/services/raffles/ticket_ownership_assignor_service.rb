# frozen_string_literal: true

module Raffles
  class TicketOwnershipAssignorService < ApplicationService
    def initialize(params)
      @product = params[:product]
      @ticket_number = params[:ticket_number]
      @order = params[:order]
      @country = params[:country]
    end

    private

    def call
      find_raffle_ticket
      create_order_item
      update_raffle_ticket
      update_order_total
    end

    def create_order_item
      @order_item = @order.order_items.create!(order_item_attributes)
    end

    def find_raffle_ticket
      @ticket = @raffle.raffle_tickets
                       .available
                       .find_by!(number: @ticket_number)
    end

    def order_item_attributes
      {
        product: @product,
        quantity: 1,
        unit_price_cents: @product.price_cents,
        total_cents: @product.price_cents
      }
    end

    def raffle_ticket_attributes
      {
        order_item: @order_item,
        user: @order.user,
        status: :reserved
      }
    end

    def update_order_total
      Shopping::UpdateCartTotals.call(@order, @country)
    end

    def update_raffle_ticket
      @ticket.update!(raffle_ticket_attributes)
    end
  end
end
