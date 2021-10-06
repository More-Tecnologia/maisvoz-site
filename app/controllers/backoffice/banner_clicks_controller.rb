module Backoffice
  class BannerClicksController < BackofficeController

    before_action :ensure_banner, only: :create

    def index; end

    def create
      ActiveRecord::Base.transaction do
        bonus_contracts.map do |bonus_contract|
          banner_click = current_user.banner_clicks
                                     .create!(params.slice(:banner_id))
          transaction = build_transaction(bonus_contract)
          credit_bonus_to(bonus_contract, transaction)

          RecurrentCreatorWorker.perform_async(current_user.id, transaction.id)
          banner_click.update(financial_transaction: transaction)
        end
      end
    end

    def bonus_contracts
      current_user.bonus_contracts.active.yield_contracts.order(:created_at)
    end

    def build_transaction(contract)
      current_user.financial_transactions
                  .create!(spreader: User.find_morenwm_customer_admin,
                           financial_reason: FinancialReason.yield_bonus,
                           moneyflow: :credit,
                           cent_amount: contract.order_items
                                                .last
                                                .earnings_per_campaign
                                                .to_f / 100.0)
    end

    def credit_bonus_to(contract, transaction)
      contract.received_balance += transaction.cent_amount.to_f
      contract.remaining_balance = contract.cent_amount - contract.received_balance.to_f
      contract.save!
    end

    def ensure_banner
      @banner = Banner.find(params[:banner_id])
    end
  end
end
