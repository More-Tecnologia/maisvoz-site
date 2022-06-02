module Backoffice
  module StoresHelper
    def banner_items_factory(banner_item)
      Dashboards::Users::StoresPresenter.new(banner_item)
    end

    def main_store_path
      if ActiveModel::Type::Boolean.new.cast(ENV['WHITELABEL'])
        raffles_backoffice_stores_path
      else
        backoffice_products_path
      end
    end
  end
end
