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

# Direct Indication Bonus
indication_bonus_scores = [[600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600]]
ActiveRecord::Base.transaction do
  product_names = ["Basic", "Vision ", "Advance", "1 Voucher Advance 50% off", "5 Voucher Advance 50% off", "10 Voucher Advance 50% off"]
  reason = FinancialReason.find_by(code: '2000')
  products = Product.where(name: product_names)
  products.each do |product|
    product_reason = ProductReasonScore.create!(product: product, financial_reason: reason)
    create_product_scores_by_trail(product, reason, product_reason, indication_bonus_scores, fix_value = false, 1)
    create_product_scores_by_trail(product, reason, product_reason, indication_bonus_scores, fix_value = false, 2)
    create_product_scores_by_trail(product, reason, product_reason, indication_bonus_scores, fix_value = false, 3)
  end
end

residual_bonus_scores = [[000, 000, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500],
                         [000, 000, 000, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500],
                         [000, 000, 000, 000, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500],
                         [000, 000, 000, 000, 000, 500, 500, 500, 500, 500, 500, 500, 500, 500]]
TRAIL_QUANTITY = 3
fix_value = false
ActiveRecord::Base.transaction do
  product_names = ['Mensality']
  reason = FinancialReason.find_by(code: '2600')
  products = Product.where(name: product_names)
  products.each do |product|
    product_reason_score = ProductReasonScore.create!(product: product, financial_reason: reason)
    TRAIL_QUANTITY.times do |i|
      trail_id = i + 1
      create_product_scores_by_trail(product,
                                     reason,
                                     product_reason_score,
                                     residual_bonus_scores,
                                     fix_value,
                                     trail_id)
    end
  end
end
