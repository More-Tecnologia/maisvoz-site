module Backoffice
  class VouchersController < EntrepreneurController

    def index
      render(:index, locals: { vouchers: current_user.vouchers.order(:used) })
    end

  end
end
