# frozen_string_literal: true

module Dashboards
  module Admins
    class IndexPresenter

      def active_products_count
        Product.active.count
      end

      def data_list
        [
          { label: I18n.t('views.dashboard.admin.today_orders'),
            value: today_orders_count },
          { label: I18n.t('views.dashboard.admin.total_orders'),
            value: orders_count },
          { label: I18n.t('views.dashboard.admin.active_products'),
            value: active_products_count },
          { label: I18n.t('views.dashboard.admin.total_users'),
            value: users_count }
        ]
      end

      def last_orders
        Order.includes(:user).last(10).reverse
      end

      def last_orders_count
        Order.created_after(10)
             .group_by_day(:created_at)
             .count
      end

      def last_users_count
        User.created_after(10)
            .group_by_day(:created_at)
            .count
      end

      def orders_count
        Order.valids.count
      end

      def today_orders_count
        Order.valids.today.count
      end

      def users_count
        User.count
      end

    end
  end
end
