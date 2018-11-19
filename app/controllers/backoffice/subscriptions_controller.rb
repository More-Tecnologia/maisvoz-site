module Backoffice
  class SubscriptionsController < BackofficeController

    def index
      @subscriptions = current_user.subscriptions
    end

    private

  end
end