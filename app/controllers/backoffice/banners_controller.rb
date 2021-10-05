module Backoffice
  class BannersController < BackofficeController
    def index
      @banners = current_user.banner_clicks
                             .today
                             .map(&:banner)
    end
  end
end
