# frozen_string_literal: true

class CourseSalePaymentWorker
  include Sidekiq::Worker

  def perform(order_item_id)
    order_item = OrderItem.find(order_item_id)
    return unless order_item.order.paid?
    
    Bonification::CourseSaleService.call(user: order_item.order.user, product: order_item.product) 
  end
end
