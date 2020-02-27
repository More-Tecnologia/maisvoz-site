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

    def balances_data
      render json: user_balances
    end

    def bonus_data
      render json: user_bonus
    end

    def earnings_data
      render json: user_earnings
    end

    def user_data
      render json: dashboard_data_constructor
    end

    private

    def dashboard_data_constructor
      DashboardUserDecorator.new(current_user).build
    end

    def user_balances
      Dashboards::Users::BalancesPresenter.new(current_user).build
    end

    def user_bonus
      Dashboards::Users::BonusPresenter.new(current_user).build
    end

    def user_earnings
      Dashboards::Users::EarningsPresenter.new(current_user).build
    end

    def last_orders
      return unless current_user.admin?
      Order.order(created_at: :desc).first(10)
    end

    def last_qualifications
      @last_qualifications ||= CareerHistory.where('user_id > 3').order(created_at: :desc).includes(:user).first(10)
    end

    def last_withdrawals
      @last_withdrawals ||= current_user.withdrawals.order(created_at: :desc).first(5)
    end

    def redirect_if_consumer
      redirect_to backoffice_products_path if current_user.consumidor?
    end

  end
end
