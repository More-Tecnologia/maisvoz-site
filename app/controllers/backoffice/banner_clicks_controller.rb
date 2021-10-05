module Backoffice
  class BannerClicksController < BackofficeController

    def index; end

    def create
      ActiveRecord::Base.transaction do
        @banner = Banner.find(params[:banner_id])
        if current_user.can_click_more_banners?
          @banner_click = current_user.banner_clicks
                                      .create!(params.slice(:banner_id))

          transaction = current_user.financial_transactions
                                    .create!(spreader: @user,
                                             financial_reason: FinancialReason.yield_bonus,
                                             moneyflow: :credit,
                                             cent_amount: current_user.current_earning)
          @banner_click.update(financial_transaction: transaction)
          RecurrentCreatorWorker.perform_async(current_user.id)
          current_user.banner_seen_today! if current_user.viewed_minimum_banner_quantity_today?
        end
      end
    end
  end
end
