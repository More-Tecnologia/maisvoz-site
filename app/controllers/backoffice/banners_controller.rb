module Backoffice
  class BannersController < BackofficeController
    before_action :show_daily_task_alert, only: :index,
                                          unless: proc { current_user.banner_seen_today? },
                                          if: proc { current_user.bonus_contracts.active.any? }

    def index
      @banners = Banner.page(params[:page])
                       .shuffle
    end
  end
end
