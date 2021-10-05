module Backoffice
  class BannersController < BackofficeController
    def index
      @banners_clicks = current_user.banner_clicks
                                    .page(params[:page])
    end
  end
end
