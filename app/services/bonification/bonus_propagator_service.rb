module Bonification
  class BonusPropagatorService < ApplicationService
    def call
      sponsors = user.unilevel_ancestors.reverse
      sponsors.each_with_index do |sponsor, index|
        propagate_product_bonus(sponsor, index + 1) if sponsor.empreendedor?
      end
    end

    private

    attr_reader :order, :user, :products, :product_reason_scores,
                :product_scores, :order_items

    def initialize(args)
      @order = args[:order]
      @user = order.user
      @products = order.products
      @product_reason_scores = find_product_reason_scores_by(products)
      @product_scores = index_product_scores_by_career_trail_id
      @order_items = order.order_items.index_by(&:product_id)
    end

    def propagate_product_bonus(ascendant_sponsor, generation)
      products.each do |product|
        ActiveRecord::Base.transaction do
          create_product_bonuses(ascendant_sponsor, generation, product)
        end
      end
    end

    def create_product_bonuses(ascendant_sponsor, generation, product)
      financial_reasons = find_financial_reasons_by(product)
      financial_reasons.each do |financial_reason|
        product_score = find_product_score(ascendant_sponsor, financial_reason, product, generation)
        return unless product_score && product_score.amount_cents > 0
        financial_transaction = create_financial_transaction(ascendant_sponsor,
                                                             generation,
                                                             product,
                                                             financial_reason,
                                                             product_score)
        return financial_transaction.chargeback! if ascendant_sponsor.inactive?
        financial_transaction.chargeback_by_career_trail_excess!(career_trail_excess_bonus) if career_trail_excess_bonus > 0
      end
    end

    def create_financial_transaction(ascendant_sponsor, generation, product, financial_reason, product_score)
      order_item_quantity = order_items.fetch(product.id).quantity.to_i
      bonus = order_item_quantity * product_score.calculate_product_score(product.price_cents)
      financial_transaction = FinancialTransaction.create!(user: ascendant_sponsor,
                                                           spreader: user,
                                                           financial_reason: financial_reason,
                                                           generation: generation,
                                                           cent_amount: bonus,
                                                           order: order)
      return financial_transaction.chargeback_by_inactivity! if ascendant_sponsor.inactive?
      excess = career_trail_excess_bonus(ascendant_sponsor)
      financial_transaction.chargeback_by_career_trail_excess!(excess) if excess > 0
      Financial::UnlockBlockedBalance.call(user: ascendant_sponsor)
    end

    def find_product_reason_scores_by(products)
      ProductReasonScore.includes(:product, :product_scores)
                        .where(product: products)
    end

    def index_product_scores_by_career_trail_id
      reason_scores = product_reason_scores.index_by(&:financial_reason_id)
      reason_scores.transform_values do |reason_score|
        reason_score.product_scores.index_by(&:career_trail_id)
      end
    end

    def find_financial_reasons_by(product)
      product_reason_scores.map { |e| e.financial_reason if e.product_id == product.id }
                           .compact
                           .uniq
    end

    def career_trail_excess_bonus
      @career_trail_excess_bonus ||= user.calculate_excess_career_trail_bonus
    end

    def find_product_score(ascendant_sponsor, financial_reason, product, generation)
      ProductScore.includes(:career_trail)
                  .joins(product_reason_score: [:product, :financial_reason])
                  .where(career_trail: ascendant_sponsor.current_career_trail)
                  .where('product_reason_scores.financial_reason_id = ?', financial_reason.id)
                  .where('product_reason_scores.product_id = ?', product.id)
                  .where(generation: generation)
    end

  end
end
