module Backoffice
  class BannerClicksController < BackofficeController

    before_action :ensure_banner, only: :create

    def index; end

    def create
      t = Time.now
      unless t.saturday? || t.sunday?
        ActiveRecord::Base.transaction do
          bonus_contracts.map do |bonus_contract|
            next if bonus_contract.max_gains?
            next unless can_click_more_banners?(bonus_contract)

            banner_click = current_user.banner_clicks
                                       .create!(params.slice(:banner_id))
            transaction = build_transaction(bonus_contract)
            credit_bonus_to(bonus_contract, transaction)

            banner_click.update(financial_transaction: transaction)
            next if free_user?

            RecurrentCreatorWorker.perform_async(current_user.id, transaction.id)
          end
        end
      end
    end

    def bonus_contracts
      current_user.bonus_contracts.active.yield_contracts.order(:created_at)
    end

    def build_transaction(contract)
      current_user.financial_transactions
                  .create!(spreader: User.find_morenwm_customer_admin,
                           financial_reason: financial_reason,
                           moneyflow: :credit,
                           bonus_contract: contract,
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

    def can_click_more_banners?(contract)
      current_user.banner_clicks.today.by_contract(contract).count < contract.order_items.last.task_per_day.to_i
    end

    def financial_reason
      free_user? ? FinancialReason.free_task_performed : FinancialReason.yield_bonus
    end

    def free_user?
      current_user.orders
                  .paid
                  .map(&:order_items)
                  .flatten
                  .all? { |x| x.product.free_product? }
    end
  end
end
