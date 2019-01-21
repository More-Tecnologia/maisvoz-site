module Backoffice
  class MyInvestmentsController < BackofficeController

    def index
      @investments = current_user.investment_shares.includes(:investment)
    end

  end
end
