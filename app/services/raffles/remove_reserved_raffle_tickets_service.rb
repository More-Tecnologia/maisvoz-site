# frozen_string_literal: true

module Raffles
  class RemoveReservedRaffleTicketsService < ApplicationService
    def initialize(params)
      @order = params[:order]
    end

    private

    def call
      order_items.each do |order_item|
        if order_item.raffle_ticket.present? && (!@order.cart? || (order_items.last.created_at + ENV["CART_TIMEOUT"].to_i.minutes < Time.now))
          order_item.raffle_ticket.update(reseted_raffle_ticket_attributes)
        end
      end
      order_items.where('created_at < ?', (Time.now - ENV["CART_TIMEOUT"].to_i.minutes)).destroy_all if @order.cart? && (order_items.last.created_at + ENV["CART_TIMEOUT"].to_i.minutes < Time.now)
    end

    def order_items
      if @order.cart?
        @order.order_items.where('created_at < ?', (Time.now - ENV["CART_TIMEOUT"].to_i.minutes))
      else
        @order.order_items
      end
    end

    def reseted_raffle_ticket_attributes
      {
        order_item: nil,
        status: :available,
        user: nil
      }
    end
  end
end
