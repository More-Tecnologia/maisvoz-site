#frozen_string_literal: true

class BalancePaymentWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    Payment::BalanceService.call(order: order)
  end
end
