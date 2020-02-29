module Backoffice
  class DashboardController < EntrepreneurController

    def index; end

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

  end
end
