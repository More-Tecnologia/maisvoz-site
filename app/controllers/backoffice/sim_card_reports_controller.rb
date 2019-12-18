module Backoffice
  class SimCardReportsController < BackofficeController

    def index
      @sim_cards = current_user.sim_cards
    end

  end
end
