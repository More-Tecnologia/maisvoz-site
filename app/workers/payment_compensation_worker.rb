class PaymentCompensationWorker

  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
<<<<<<< HEAD
    order.pending_payment! if order.expired?
=======
    order.pending_payment!
>>>>>>> 289cffe869e3b7b66981fdf8c7d2e802262c6e94
    Financial::PaymentCompensation.new(order).call
  end

end
