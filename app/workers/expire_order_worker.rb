class ExpireOrderWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)

    Shopping::ExpireOrderService.call(order)
  end
end
