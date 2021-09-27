module Backoffice
  class BannerClicksController < BackofficeController

    def index; end

    def create
      ActiveRecord::Base.transaction do
        @banner = Banner.find(params[:banner_id])
        if current_user.total_banners_per_day.positive?
          @banner_click = current_user.banner_clicks
                                      .create!(params.slice(:banner_id))

          current_user.financial_transactions
                      .create!(spreader: @user,
                               financial_reason: FinancialReason.yield_bonus,
                               moneyflow: :credit,
                               cent_amount: current_user.current_earning) if current_user.current_earning.positive?
          RecurrentCreatorWorker.perform_async(current_user.id)
        end

        current_user.banner_seen_today! if current_user.viewed_minimum_banner_quantity_today?
      end
    end
  end
end
