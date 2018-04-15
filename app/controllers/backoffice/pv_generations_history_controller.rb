module Backoffice
  class PvGenerationsHistoryController < EntrepreneurController

    def index
      render locals: { pv_activity_sum: pv_activity_sum }
    end

    private

    def pv_activity_sum
      PvActivityHistory.where(user: current_user).where('height > 1').group('height').sum('amount')
    end

  end
end
