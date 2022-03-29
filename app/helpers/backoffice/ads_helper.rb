module Backoffice
  module AdsHelper
    def any_active_waiting_ad?
      BannerStore.ads_store
                 .banners
                 .includes(:order)
                 .select(&:approvable?)
                 .any?
    end
  end
end
