# frozen_string_literal: true

class RemoveReservedRaffleTicketsWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    unless order.completed?
      Raffles::RemoveReservedRaffleTicketsService.call(order: order)
    end
  end
end
