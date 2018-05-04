class SAPOrderTransmitterWorker

  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    SAPOrderTransmitter.new(order).call
  end

end
