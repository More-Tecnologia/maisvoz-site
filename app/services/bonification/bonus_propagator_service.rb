module Bonification
  class BonusPropagatorService < ApplicationService
    def call
      ascendant_sponsors = user.ascendant_sponsors
      ascendant_sponsors.each_with_index do |ascendant_sponsor, index|
        propagate_product_bonus(ascendant_sponsor, index + 1)
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
        product_score = product_scores.fetch(financial_reason.id)
                                      .fetch(ascendant_sponsor.current_career_trail.id)
        return unless product_score
        financial_transaction = create_financial_transaction(ascendant_sponsor,
                                                             generation,
                                                             product,
                                                             financial_reason,
                                                             product_score)
        financial_transaction.chargeback! unless ascendant_sponsor.active?
      end
    end

    def create_financial_transaction(ascendant_sponsor, generation, product, financial_reason, product_score)
      order_item_quantity = order_items.fetch(product.id).quantity.to_i
      score = order_item_quantity * product_score.calculate_product_score(product.price_cents)
      FinancialTransaction.create!(user: ascendant_sponsor,
                                   spreader: user,
                                   financial_reason: financial_reason,
                                   generation: generation,
                                   cent_amount: score.round(0),
                                   order: order) if score > 0
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
  end
end
