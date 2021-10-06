module Backoffice
  class DashboardController < EntrepreneurController
    before_action :ensure_contracts, only: :index
    before_action :ensure_no_admin_user, only: :index

    def index
      contract = @contracts.last
      @total_banners_per_day = contract.order_items.last.task_per_day.to_i
      @banners_clicked_today_quantity = current_user.banner_clicks
                                                    .today
                                                    .by_contract(contract)
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

    def ensure_no_admin_user
      redirect_to backoffice_admin_dashboard_index_path if user_signed_in? && (current_user.admin? || current_user.financeiro?)
    end
  end
end
