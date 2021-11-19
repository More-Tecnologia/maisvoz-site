module Backoffice
  class DashboardController < EntrepreneurController
    before_action :ensure_contracts, only: :index
    before_action :contracts_by_value, only: :index
    before_action :ensure_no_admin_user, only: :index

    def index
      @max_task_gains = @contracts.sum(&:max_task_gains)
      @task_gains = @contracts.sum(&:task_gains)
      available = @max_task_gains - @task_gains
      @available_gains = available.positive? ? available : 0
      @contract = @contracts.last
      @most_value_contract = @contracts_by_value.last
      @total_banners_per_day = @contract.present? ? @contract.order_items.last.task_per_day.to_i : 0
      @banners_clicked_today_quantity = current_user.banner_clicks
                                                    .today
                                                    .by_contract(@contract)
                                                    .count
    end

    def balances_data
      render json: Dashboards::Users::BalancesPresenter.new(current_user)
                                                       .build
    end

    def binary_counts_data
      render json: Dashboards::Users::BinaryCountsPresenter.new(current_user)
                                                           .build
    end

    def binary_scores_data
      render json: Dashboards::Users::BinaryScoresPresenter.new(current_user)
                                                           .build
    end

    def bonus_data
      render json: Dashboards::Users::BonusPresenter.new(current_user)
                                                    .build
    end

    def earnings_data
      render json: Dashboards::Users::EarningsPresenter.new(current_user)
                                                       .build
    end

    def unilevel_counts_data
      render json: Dashboards::Users::UnilevelCountsPresenter.new(current_user)
                                                             .build
    end

    private

    def ensure_contracts
      @contracts = current_user.bonus_contracts.active.sort do |contract, other|
        contract.order_items.last.task_per_day.to_i <=> other.order_items.last.task_per_day.to_i
      end
    end

    def contracts_by_value
      @contracts_by_value = @contracts.sort do |contract, other|
        contract.order_items.last.unit_price_cents <=> other.order_items.last.unit_price_cents
      end
    end

    def ensure_no_admin_user
      redirect_to backoffice_admin_dashboard_index_path if user_signed_in? && (current_user.admin? || current_user.financeiro?)
    end
  end
end
