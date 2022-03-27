# frozen_string_literal: true

class AdsDirectIndirectWorker
  include Sidekiq::Worker

  def perform(order_id, ad_id, amount)
    order = Order.find(order_id)
    ad = Banner.find(ad_id)

    return unless order.paid? && !ad.billed? && ad.approved?

    Bonification::AdsDirectIndirectCreatorService.call(ad: ad, amount: amount)
  end
end
