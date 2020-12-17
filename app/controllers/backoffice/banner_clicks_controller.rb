module Backoffice
  class BannerClicksController < BackofficeController
    skip_before_action :redirect_to_banners
    
    def index; end

    def create
      ActiveRecord::Base.transaction do
        @banner_click = current_user.banner_clicks
                                    .create!(params.slice(:banner_id))
        if current_user.viewed_minimum_banner_quantity_today?
          current_user.banner_seen_today!
          Bonification::ClickcashCreatorService.call(user: current_user)
        end
      end
    end
  end
end
