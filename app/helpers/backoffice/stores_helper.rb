module Backoffice
  module StoresHelper
    def banner_items_factory(banner_item)
      Dashboards::Users::StoresPresenter.new(banner_item)
    end
  end
end
