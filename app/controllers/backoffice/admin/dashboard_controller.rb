# frozen_string_literal: true

module Backoffice
  module Admin
    class DashboardController < EntrepreneurController
      def index
        @last_orders = Order.order(created_at: :desc).first(10)
        @last_users_count = User.where('created_at >= ?', 10.days.ago.beginning_of_day).group_by_day(:created_at).count
        @last_orders_count = Order.where('created_at >= ?', 10.days.ago.beginning_of_day).group_by_day(:created_at).count
        @active_products_count = Product.active.count
        @users_count = User.count
        @orders_count = Order.where.not(status: Order.statuses[:cart]).count
        @today_orders_count = Order.where.not(status: Order.statuses[:cart]).or(Order.where.not(status: Order.statuses[:expired])).today.count
      end

      def bonus_data
        render json: { data: '' }
      end

      def payment_data
        render json: { data: '' }
      end

      def withdrawals_data
        render json: { data: ''}
      end
    end
  end
end
