class PaymentCompensationWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    order.pending_payment! if order.expired?
    Financial::PaymentCompensation.new(order).call
  end
end
