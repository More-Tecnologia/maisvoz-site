module Backoffice
  class AccumulatedPvaController < BackofficeController

    def index
      render(:index, locals: { sponsored: sponsored, user: user })
    end

    private

    def user
      current_user.decorate
    end

    def sponsored
      @sponsored ||= current_user.sponsored.order(pva_total: :desc).decorate
    end

  end
end
