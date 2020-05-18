module Bonification
  class BonusPropagatorService < ApplicationService

    def call
      return if @order.total_value <= 50
      products.each do |product|
        ActiveRecord::Base.transaction do
          create_bonus_by(product)
        end
      end
    end

    private

    attr_reader :order, :user, :products, :product_reason_scores,
                :product_scores, :order_items, :customer_admin

    def initialize(args)
      @order = args[:order]
      @user = order.user
      @products = args[:products] || order.products
      @product_reason_scores = find_product_reason_scores_by(products)
      @order_items = order.order_items.index_by(&:product_id)
      @customer_admin = User.find_morenwm_customer_admin
    end

    def create_bonus_by(product)
      product_reasons = product_reason_scores.select { |prs| prs.product == product }
      product_reasons.each do |product_reason|
        financial_reason = product_reason.financial_reason
        sponsors = find_sponsors_by(product_reason, financial_reason.dynamic_compression)
        create_financial_transactions_to(sponsors, product, financial_reason, product_reason)
      end
    end

    def create_financial_transactions_to(sponsors, product, financial_reason, product_reason)
      sponsors.each_with_index do |sponsor, index|
        next unless sponsor.empreendedor?
        generation = index + 1
        product_score = detect_product_score_by(sponsor, generation, product_reason)
        next unless product_score.try(:amount_cents).to_f > 0
        financial_transaction =
          create_financial_transaction_by(sponsor, generation, product, product_score, financial_reason)
      end
    end

    def detect_product_score_by(sponsor, generation, product_reason)
      product_scores = product_reason.product_scores
      pay_by_requalification_score =
        should_pay_bonus_by_requalification_score?(product_reason, sponsor)
      receiver_career_trail =
        pay_by_requalification_score ? Career.detect_requalification_career_trail(sponsor) : sponsor.current_career_trail
      product_scores.detect do |s|
        s.generation == generation &&
        s.career_trail_id == receiver_career_trail.id
      end
    end

    def should_pay_bonus_by_requalification_score?(product_reason, sponsor)
      reason_pay_bonus_by_requalification_score = product_reason.pay_bonus_by_requalification_score
      qualification_date = sponsor.current_career_trail_user.created_at
      qualified_more_than_1_month = qualification_date + 1.month <= Date.current
      reason_pay_bonus_by_requalification_score && qualified_more_than_1_month
    end

    def find_sponsors_by(product_reason, dynamic_compression)
      product_scores = product_reason.product_scores
      receiver_generations_count = product_scores.map(&:generation).max
      unilevel_nodes = if dynamic_compression
                          user.unilevel_node
                              .ancestors
                              .dynamic_compression(receiver_generations_count)
                       else
                         user.unilevel_node
                             .ancestors
                             .bonus_receivers(receiver_generations_count)
                       end
      unilevel_nodes.is_a?(Array) ? unilevel_nodes.reverse.map(&:user) : [unilevel_nodes.user]
    end

    def create_financial_transaction_by(sponsor, generation, product, product_score, financial_reason)
      order_item_quantity = order_items.fetch(product.id).quantity.to_i
      bonus = order_item_quantity * product_score.calculate_product_score(product.price_cents)
      transaction =
        sponsor.financial_transactions.create!(spreader: user,
                                               financial_reason: financial_reason,
                                               generation: generation,
                                               cent_amount: bonus,
                                               order: order.loan_payment ? nil : order) if bonus > 0
      chargeback_by_inactivity!(transaction, financial_reason) if sponsor.inactive?
      transaction
    end

    def chargeback_by_inactivity!(transaction, financial_reason)
      transaction.chargeback_by_inactivity!(financial_reason.chargeback_by_inactivity)
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
