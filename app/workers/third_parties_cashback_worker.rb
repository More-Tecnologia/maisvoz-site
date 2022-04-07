# frozen_string_literal: true

class ThirdPartiesCashbackWorker
  include Sidekiq::Worker

  def perform(order_id, user_id)
    user = User.find(user_id)
    order = Order.find(order_id)
    Payment::ThirdPartiesCashbackService.call(user: user, order: order)
  end
end
