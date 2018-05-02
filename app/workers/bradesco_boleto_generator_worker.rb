class BradescoBoletoGeneratorWorker

  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    Payment::BradescoBoleto.new(order).call
  end

end
