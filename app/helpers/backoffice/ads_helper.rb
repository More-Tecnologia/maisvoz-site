module Backoffice
  module AdsHelper
    def any_active_waiting_ad?
      BannerStore.ads_store.banners.pending.active.any?
    end
  end
end
