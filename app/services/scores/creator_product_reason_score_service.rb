module Scores
  class CreatorProductReasonScoreService < ApplicationService

    TRAIL_QUANTITY = Trail.count

    def call
      ActiveRecord::Base.transaction do
        @reason.product_reason_scores.destroy_all
        @products.each do |product|
          create_product_reason_score(product)
        end
      end
    end

    private

    attr_accessor :products, :reason, :referral_bonus, :fix_value

    def initialize(args)
      @products       = args[:products]
      @reason         = args[:reason]
      @referral_bonus = args[:referral_bonus]
      @fix_value      = args[:fix_value]
    end

    def create_product_reason_score(product)
      product_reason_score = ProductReasonScore.create!(product: product, financial_reason: @reason)
      TRAIL_QUANTITY.times do |i|
        trail_id = i + 1
        create_product_scores_by_trail(product_reason_score,
                                       @referral_bonus,
                                       trail_id)
      end
    end

    def create_product_scores_by_trail(product_reason_score, referral_bonus, trail_id)
      @career_trails ||= CareerTrail.all
      referral_bonus.each_with_index do |generation_scores, index|
        generation_scores.each_with_index do |amount_cents, idx|
          career_trails = @career_trails.select { |c| c.career_id == idx + 1 && c.trail_id == trail_id }
          career_trails.each do |career_trail|
            product_reason_score.product_scores
                                .create!(career_trail: career_trail,
                                         generation: index + 1,
                                         amount_cents: amount_cents,
                                         fix_value: @fix_value)
          end
        end
      end
    end

  end 
end
