# frozen_string_literal: true

module Raffles
  class RemoveReservedRaffleTicketsService < ApplicationService
    def initialize(params)
      @order = params[:order]
    end

    private

    def call
      order_items.each do |order_item|
        order_item.raffle_ticket.update(reseted_raffle_ticket_attributes) if order_item.raffle_ticket.present?
      end     
    end

    def order_items
      @order.order_items
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
