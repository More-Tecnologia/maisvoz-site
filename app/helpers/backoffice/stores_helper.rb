module Backoffice
  module StoresHelper
    def banner_items_factory(banner_item)
      Dashboards::Users::StoresPresenter.new(banner_item)
    end

    def main_store_path
      if SystemConfiguration.whitelabel?
        raffles_backoffice_stores_path
      else
        raffles_backoffice_stores_path
      end
    end
  end
end
