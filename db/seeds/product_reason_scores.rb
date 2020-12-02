def create_product_scores_by_trail(product, reason, product_reason, scores, fix_value, trail_id)
  @career_trails ||= CareerTrail.all
  scores.each_with_index do |generation_scores, index|
    generation_scores.each_with_index do |amount_cents, idx|
      career_trails = @career_trails.select { |c| c.career_id == idx + 1 && c.trail_id == trail_id }
      career_trails.each do |career_trail|
        product_reason.product_scores
                      .create!(career_trail: career_trail,
                               generation: index + 1,
                               amount_cents: amount_cents,
                               fix_value: fix_value)
      end
    end
  end
end

direct_referral_bonus = [[000, 1000, 1000, 1000, 1000, 1000, 1000, 1000]]
TRAIL_QUANTITY = Trail.count
fix_value = false
ActiveRecord::Base.transaction do
  reason = FinancialReason.direct_commission_bonus
  reason.product_reason_scores.destroy_all
  products = Product.all
  products.each do |product|
    product_reason_score = ProductReasonScore.create!(product: product, financial_reason: reason)
    TRAIL_QUANTITY.times do |i|
      trail_id = i + 1
      create_product_scores_by_trail(product,
                                     reason,
                                     product_reason_score,
                                     direct_referral_bonus,
                                     fix_value,
                                     trail_id)
    end
  end
end

indirect_referral_bonus = [ [000, 000, 000, 000, 000, 000, 000, 000],
                            [000, 400, 400, 400, 400, 400, 400, 400],
                            [000, 200, 200, 200, 200, 200, 200, 200],
                            [000, 100, 100, 100, 100, 100, 100, 100],
                            [000, 100, 100, 100, 100, 100, 100, 100],
                            [000, 100, 100, 100, 100, 100, 100, 100],
                            [000, 100, 100, 100, 100, 100, 100, 100],
                            [000, 100, 100, 100, 100, 100, 100, 100],
                            [000, 100, 100, 100, 100, 100, 100, 100],
                            [000, 100, 100, 100, 100, 100, 100, 100]]
TRAIL_QUANTITY = Trail.count
fix_value = false
ActiveRecord::Base.transaction do
  reason = FinancialReason.indirect_referral_bonus
  reason.product_reason_scores.destroy_all
  products = Product.all
  products.each do |product|
    product_reason_score = ProductReasonScore.create!(product: product, financial_reason: reason)
    TRAIL_QUANTITY.times do |i|
      trail_id = i + 1
      create_product_scores_by_trail(product,
                                     reason,
                                     product_reason_score,
                                     indirect_referral_bonus,
                                     fix_value,
                                     trail_id)
    end
  end
end
