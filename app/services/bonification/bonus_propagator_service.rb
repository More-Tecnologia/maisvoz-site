module Bonification
  class BonusPropagatorService < ApplicationService

    def call
      products.each do |product|
        ActiveRecord::Base.transaction do
          create_bonus_by(product)
        end
      end
    end

    private

    attr_reader :order, :user, :products, :product_reason_scores,
                :product_scores, :order_items, :sponsor_inactive_bonus, :customer_admin

    def initialize(args)
      @order = args[:order]
      @user = order.user
      @products = order.products
      @product_reason_scores = find_product_reason_scores_by(products)
      @order_items = order.order_items.index_by(&:product_id)
      @sponsor_inactive_bonus = []
      @customer_admin = User.find_morenwm_customer_admin
    end

    def create_bonus_by(product)
      financial_reasons = find_financial_reasons_by(product)
      financial_reasons.each do |financial_reason|
        sponsor_inactive_bonus = []
        product_scores = find_product_scores_by(financial_reason)
        sponsors = find_sponsors_by(product_scores)
        byebug
        create_financial_transactions_to(sponsors, product, financial_reason, product_scores)
      end
    end

    def create_financial_transactions_to(sponsors, product, financial_reason, product_scores)
      sponsors.each_with_index do |sponsor, index|
        next unless sponsor.empreendedor? && !sponsor.support_point?
        generation = index + 1
        product_score = detect_product_score_by(sponsor, generation, product_scores)
        next unless product_score.try(:amount_cents).to_f > 0
        financial_transaction =
          create_financial_transaction_by(sponsor, generation, product, product_score, financial_reason)
        Financial::UnlockBlockedBalance.call(user: sponsor)
      end
    end

    def detect_product_score_by(sponsor, generation, product_scores)
      product_scores.detect do |s|
        s.generation == generation &&
        s.career_trail_id == sponsor.current_career_trail.id
      end
    end

    def find_sponsors_by(product_scores)
      receiver_generations_count = product_scores.map(&:generation).max
      unilevel_nodes = user.unilevel_node
                           .ancestors
                           .includes(user: [career_trail_users: [career_trail: [trail: [:product]]]])
                           .last(receiver_generations_count)
      unilevel_nodes.reverse
                    .map(&:user)
    end

    def create_financial_transaction_by(sponsor, generation, product, product_score, financial_reason)
      order_item_quantity = order_items.fetch(product.id).quantity.to_i
      bonus = order_item_quantity * product_score.calculate_product_score(product.price_cents)
      byebug
      transaction =
        sponsor.financial_transactions.create!(spreader: user,
                                               financial_reason: financial_reason,
                                               generation: generation,
                                               cent_amount: bonus,
                                               order: order)
      chargeback_by_inactivity!(transaction, financial_reason) if sponsor.inactive?
      sponsor_inactive_bonus =
        process_dynamic_compression(sponsor, bonus, generation) if financial_reason.dynamic_compression
      excess = career_trail_excess_bonus(sponsor)
      transaction.chargeback_by_career_trail_excess!(excess) if excess > 0
    end

    def chargeback_by_inactivity!(transaction, financial_reason)
      transaction.chargeback_by_inactivity!(financial_reason.chargeback_by_inactivity)
    end

    def process_dynamic_compression(sponsor)
      return sponsor_inactive_bonus.push(cent_amount: bonus, generation: generation) if sponsor.inactive?
      create_sponsor_inactive_bonus_to(sponsor, financial_reason) if sponsor_inactive_bonus.any?
      []
    end

    def create_sponsor_inactive_bonus_to(sponsor, financial_reason)
      sponsor_inactive_bonus.each do |bonus|
        sponsor.financial_transactions.create!(financial_reason: financial_reason,
                                               cent_amount: bonus[:cent_amount],
                                               generation: bonus[:generation],
                                               order: order,
                                               spreader: user)
      end
    end

    def find_product_reason_scores_by(products)
      ProductReasonScore.includes(:product,
                                  :product_scores,
                                  financial_reason: [:chargeback_by_inactivity, :financial_reason_type])
                        .where(product: products)
    end

    def find_financial_reasons_by(product)
      product_reason_scores.map { |e| e.financial_reason if e.product_id == product.id }
                           .compact
                           .uniq
    end

    def career_trail_excess_bonus(sponsor)
      sponsor.calculate_excess_career_trail_bonus
    end

    def find_product_scores_by(financial_reason)
      product_reason_scores.detect { |s| s.financial_reason_id == financial_reason.id }.try(:product_scores)
    end

  end
end
