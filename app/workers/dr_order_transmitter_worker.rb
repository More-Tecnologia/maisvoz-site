class DROrderTransmitterWorker

  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    DROrderTransmitter.new(order).call
  end

end
