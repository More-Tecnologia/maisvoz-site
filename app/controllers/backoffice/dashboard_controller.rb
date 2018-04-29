module Backoffice
  class DashboardController < EntrepreneurController

    # before_action :redirect_if_consumer

    def index
      render(
        :index,
        locals: {
          last_orders: last_orders,
          last_qualifications: last_qualifications,
          last_withdrawals: last_withdrawals
        }
      )
    end

    private

    def last_orders
      return unless current_user.admin?
      Order.order(created_at: :desc).first(10)
    end

    def last_qualifications
      @last_qualifications ||= CareerHistory.order(created_at: :desc).includes(:user).first(10)
    end

    def last_withdrawals
      @last_withdrawals ||= current_user.withdrawals.order(created_at: :desc).first(5)
    end

    def redirect_if_consumer
      redirect_to backoffice_products_path if current_user.consumidor?
    end

  end
end
