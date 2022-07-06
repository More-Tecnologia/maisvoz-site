# frozen_string_literal: true

class RemoveReservedRaffleTicketsWorker
  include Sidekiq::Worker

  def perform(order_id, cart = false)
    order = Order.find(order_id)
    unless order.completed? || (cart && !order.cart?)
      Raffles::RemoveReservedRaffleTicketsService.call(order: order)
    end
  end
end
