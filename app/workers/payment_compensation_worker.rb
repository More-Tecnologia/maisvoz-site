class PaymentCompensationWorker

  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    order.pending_payment!
    Financial::PaymentCompensation.new(order).call
  end

end
