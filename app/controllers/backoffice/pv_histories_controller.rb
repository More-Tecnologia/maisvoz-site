module Backoffice
  class PvHistoriesController < BackofficeController

    def index
      render(:index, locals: { pv_histories: pv_histories })
    end

    private

    def pv_histories
      current_user.pv_histories.where(
        direction: direction
      ).order(
        created_at: :desc
      ).page(params[:page]).includes(:order)
    end

    def direction
      return :left if params[:direction].blank?
      if params[:direction] == 'left'
        :left
      else
        :right
      end
    end

  end
end
