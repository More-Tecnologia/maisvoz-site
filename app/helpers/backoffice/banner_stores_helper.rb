module Backoffice
  module BannerStoresHelper
    def banner_stores_for_select
      @banner_stores_for_select ||=
        BannerStore.select(:id, :title).pluck(:title, :id)
    end
  end
end
