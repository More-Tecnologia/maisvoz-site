module Backoffice
  class PvActivityHistoriesController < EntrepreneurController

    def index
      render(:index, locals: { pv_activity_histories: pv_activity_histories, pv_activity_histories_sum: pv_activity_histories_sum })
    end

    private

    def pv_activity_histories
      pv_activity_histories_query.page(params[:page]).includes(order: :user)
    end

    def pv_activity_histories_sum
      pv_activity_histories_query.sum(:amount)
    end

    def pv_activity_histories_query
      @pv_activity_histories_query ||= PvActivityHistoriesQuery.new(
        current_user.pv_activity_histories
      ).call(params, false)
    end

  end
end
