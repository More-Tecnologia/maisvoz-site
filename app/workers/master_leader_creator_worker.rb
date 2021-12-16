class MasterLeaderCreatorWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)

    Bonification::MasterLeaderCreatorService.call(order: order)
  end
end
