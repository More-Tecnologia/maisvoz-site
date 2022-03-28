# frozen_string_literal: true

class AdsDirectIndirectWorker
  include Sidekiq::Worker

  def perform(ad_id)
    ad = Banner.find(ad_id)
    return unless ad.order.paid? && !ad.billed? && ad.approved?

    Bonification::AdsDirectIndirectCreatorService.call(ad: ad)
  end
end
