module Backoffice
  class PvActivityHistoriesController < BackofficeController

    def index
      render(:index, locals: { pv_activity_histories: pv_activity_histories })
    end

    private

    def pv_activity_histories
      current_user.pv_activity_histories.order(
        created_at: :desc
      ).page(params[:page]).includes(order: :user)
    end

  end
end
