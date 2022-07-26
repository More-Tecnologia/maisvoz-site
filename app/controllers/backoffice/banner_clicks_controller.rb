# frozen_string_literal: true

module Backoffice
  class BannerClicksController < BackofficeController

    before_action :ensure_banner, only: :create

    def index; end

    def create
      @banner.decrement_click_count!
      t = Time.now
      unless t.saturday? || t.sunday?
        ActiveRecord::Base.transaction do
          bonus_contracts.map do |bonus_contract|
            next if bonus_contract.max_gains?
            next unless can_click_more_banners?(bonus_contract)

            banner_click = current_user.banner_clicks
                                       .create!(params.slice(:banner_id))
            transactions = build_transactions(bonus_contract)
            transactions.each do |transaction|
              credit_bonus_to(transaction.bonus_contract, transaction)
            end
            if free_user? && current_user.reached_free_contract_gain?
              send_current_user_to_interspire
            end
            banner_click.update(financial_transaction: transactions.first)
            next if free_user?
            transactions.each do |transaction|
              RecurrentCreatorWorker.perform_async(current_user.id, transaction.id)
            end
          end
        end
      end
    end

    def bonus_contracts
      current_user.bonus_contracts.active.yield_contracts.order(:created_at)
    end

    def build_transactions(contract)
      cent_amount = contract.order_items
                            .last
                            .earnings_per_campaign
                            .to_f / 100.0
      Bonification::GenericBonusCreatorService.call({
        amount: cent_amount,
        spreader: User.find_morenwm_customer_admin,
        sponsor: current_user,
        reason: financial_reason,
        chargebackable: true,
        bonus_contract: contract
      })
    end

    def credit_bonus_to(contract, transaction)
      contract.received_balance += transaction.cent_amount.to_f
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
      @free_user ||= current_user.orders
                                 .paid
                                 .map(&:order_items)
                                 .flatten
                                 .all? { |x| x.product.free? }
    end

    def send_current_user_to_interspire
      Interspire::ContactAdderWorker.perform_async(current_user.id)
    end
  end
end
