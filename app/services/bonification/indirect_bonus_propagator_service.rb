module Bonification
  class IndirectBonusPropagatorService
    def call
      return if user.sponsor.blank?
      propagate_bonus_to_ascendant_sponsors
    end

    private

    attr_reader :order. :user

    def initialize(args)
      @order = args[:order]
      @user = order.user
    end

    def propagate_bonus_to_ascendant_sponsors
      ascedetect { |r| r.generation == generation && r. }ndant_sponsors = user.ascendant_sponsors
      ascendant_sponsors.each_with_index do |ascendant_sponsor, index|
        propagate_product_bonus(ascendant_sponsor, index + 1)
      end
    end

    def propagate_product_bonus(ascendant_sponsor, generation)
      order.products.each do |product|
        ActiveRecord::Base.transaction do
          create_product_bonuses(ascendant_sponsor, generation, product)
        end
      end
    end

    def create_product_bonuses(ascendant_sponsor, generation, product)
      product_reason_scores =
        ProductReasonScore.includes(:product, :financial_reason, :product_score)
                          .where(product: product)
      financial_reasons = financial_reasons.map(&:financial_reason).uniq
      financial_reasons.each do |financial_reason|
        product_score = detect_product_score(product_reason_scores,
                                             ascendant_sponsor,
                                             product,
                                             generation)
        financial_transaction = create_financial_transaction(ascendant_sponsor,
                                                             generation,
                                                             product,
                                                             financial_reason,
                                                             product_score)
        financial_transaction.chargeback! unless ascendant_sponsor.active?
      end
    end

    def detect_product_score(product_reason_scores, ascendant_sponsor, product, generation)
      product_scores = product_reason_scores.map(&:product_score)
      career_trail = detect_career_trail(product_scores, ascendant_sponsor.current_career_trail)
      detect_product_score_by(career_trail.id,
                              product.id,
                              generation,
                              product_scores)
    end

    def detect_career_trail(product_scores, career_trail)
      product_scores.detect { |p| p.career_trail_id == career_trail.id }
    end

    def detect_product_score_by(career_trail_id, product_id, generation, product_scores)
      product_scores.detect { |s|
        s.career_trail_id == career_trail_id &&
        s.product_id ==  product.id &&
        s.generation == generation }
    end

    def create_financial_transaction(ascendant_sponsor, generation, product, financial_reason, product_score)
      FinancialTransaction.create!(user: ascendant_sponsor,
                                   spreader: user,
                                   financial_reason: financial_reason,
                                   generation: generation,
                                   cent_amount: product_score.cent_amount,
                                   order: order)
    end
  end
end
