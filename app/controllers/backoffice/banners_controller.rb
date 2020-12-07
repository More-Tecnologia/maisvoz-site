module Backoffice
  class BannersController < BackofficeController
    skip_before_action :redirect_to_banners
    before_action :show_daily_task_alert, only: :index,
                                          unless: proc { current_user.banner_seen_today? }

    def index
      @banners = Banner.page(params[:page])
    end
  end
end
