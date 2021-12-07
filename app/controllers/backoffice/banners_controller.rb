module Backoffice
  class BannersController < BackofficeController
    def index
      @banners_clicks = current_user.banner_clicks
                                    .order(created_at: :desc)
                                    .page(params[:page])
                                    .per(10)
    end
  end
end
