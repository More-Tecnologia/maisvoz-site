module Backoffice
  class AdsController < BackofficeController
    def index
      @ads = current_user.ads
    end
  end
end