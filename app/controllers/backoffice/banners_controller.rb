module Backoffice
  class BannersController < BackofficeController
    def index
      current_user.update!(banners_seen_at: Date.today)
    end
  end
end
