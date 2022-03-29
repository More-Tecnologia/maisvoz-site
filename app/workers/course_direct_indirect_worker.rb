# frozen_string_literal: true

class CourseDirectIndirectWorker
  include Sidekiq::Worker

  def perform(order_id, amount)
    order = Order.find(order_id)
    return unless order.paid?

    Bonification::CourseDirectIndirectCreatorService.call(user: order.user, amount: amount)
  end
end
