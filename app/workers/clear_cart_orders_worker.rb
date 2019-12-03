class ClearCartOrdersWorker
  include Sidekiq::Worker

  def perform
    Shopping::ClearCartOrders.call
  end
end
