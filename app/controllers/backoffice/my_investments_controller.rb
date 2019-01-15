module Backoffice
  class MyInvestmentsController < BackofficeController

    def index
      @investments = current_user.investment_shares
    end

  end
end
