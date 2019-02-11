class DROrderTransmitterWorker

  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    Dr::OrderTransmitter.new(order).call
  end

end
