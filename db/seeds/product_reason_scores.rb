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
elite_scores = [[4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000]]
premium_scores = [[8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000]]

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2000')
  product = Product.find_by(name: 'Elite')
  product_reason = ProductReasonScore.create!(product: product, financial_reason: reason)

  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = true, 1)
  create_product_scores_by_trail(product, reason, product_reason, premium_scores, fix_value = true, 2)
end

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2000')
  product = Product.find_by(name: 'Premium')
  product_reason = ProductReasonScore.create!(product: product, financial_reason: reason)

  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = true, 1)
  create_product_scores_by_trail(product, reason, product_reason, premium_scores, fix_value = true, 2)
end

# Indirect Indication Bonus

elite_scores = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500],
                [0, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500],
                [0, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500],
                [0, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500]]

 premium_scores = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                   [0, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
                   [0, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
                   [0, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
                   [0, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000]]

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2200')
  product = Product.find_by(name: 'Elite')
  product_reason = ProductReasonScore.create!(product: product, financial_reason: reason)

  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = true, 1)
  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = true, 2)
end

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2200')
  product = Product.find_by(name: 'Premium')
  product_reason = ProductReasonScore.create!(product: product, financial_reason: reason)

  create_product_scores_by_trail(product, reason, product_reason, premium_scores, fix_value = true, 1)
  create_product_scores_by_trail(product, reason, product_reason, premium_scores, fix_value = true, 2)
end

# Activation Bonus
elite_scores = [[0, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500],
                [000, 000, 400, 400, 400, 400, 400, 400, 400, 400, 400],
                [000, 000, 000, 200, 200, 200, 200, 200, 200, 200, 200],
                [000, 000, 000, 000, 200, 200, 200, 200, 200, 200, 200],
                [000, 000, 000, 000, 000, 150, 150, 150, 150, 150, 150],
                [000, 000, 000, 000, 000, 000, 150, 150, 150, 150, 150],
                [000, 000, 000, 000, 000, 000, 000, 100, 100, 100, 100],
                [000, 000, 000, 000, 000, 000, 000, 000, 100, 100, 100],
                [000, 000, 000, 000, 000, 000, 000, 000, 000, 100, 100],
                [000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 100]]

premium_scores = [[000, 700, 700, 700, 700, 700, 700, 700, 700, 700, 700],
                  [000, 000, 500, 500, 500, 500, 500, 500, 500, 500, 500],
                  [000, 000, 000, 300, 300, 300, 300, 300, 300, 300, 300],
                  [000, 000, 000, 000, 000, 300, 300, 300, 300, 300, 300],
                  [000, 000, 000, 000, 000, 250, 250, 250, 250, 250, 250],
                  [000, 000, 000, 000, 000, 000, 250, 250, 250, 250, 250],
                  [000, 000, 000, 000, 000, 000, 000, 200, 200, 200, 200],
                  [000, 000, 000, 000, 000, 000, 000, 000, 200, 200, 200],
                  [000, 000, 000, 000, 000, 000, 000, 000, 000, 150, 150]]

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2400')
  product = Product.find_by(name: 'Recarga de Ativação R$ 99,90')
  product_reason = ProductReasonScore.create!(product: product,
                                              financial_reason: reason,
                                              pay_bonus_by_requalification_score: true)

  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = true, 1)
  create_product_scores_by_trail(product, reason, product_reason, premium_scores, fix_value = true, 2)
end

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2400')
  product = Product.find_by(name: 'Recarga de Ativação R$ 129,90')
  product_reason = ProductReasonScore.create!(product: product,
                                              financial_reason: reason,
                                              pay_bonus_by_requalification_score: true)

  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = true, 1)
  create_product_scores_by_trail(product, reason, product_reason, premium_scores, fix_value = true, 2)
end

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2400')
  product = Product.find_by(name: 'Recarga de Ativação R$ 149,90')
  product_reason = ProductReasonScore.create!(product: product,
                                              financial_reason: reason,
                                              pay_bonus_by_requalification_score: true)

  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = true, 1)
  create_product_scores_by_trail(product, reason, product_reason, premium_scores, fix_value = true, 2)
end

# Residual Bonus

elite_scores = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100],
                [0, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100],
                [0, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100],
                [0, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100]]

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2600')
  product = Product.find_by(name: 'Recarga 34,90')
  product_reason = ProductReasonScore.create!(product: product,
                                              financial_reason: reason,
                                              pay_bonus_by_requalification_score: true)

  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = false, 1)
  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = false, 2)
end

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2600')
  product = Product.find_by(name: 'Recarga 44,90')
  product_reason = ProductReasonScore.create!(product: product,
                                              financial_reason: reason,
                                              pay_bonus_by_requalification_score: true)

  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = false, 1)
  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = false, 2)
end

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2600')
  product = Product.find_by(name: 'Recarga 69,90')
  product_reason = ProductReasonScore.create!(product: product,
                                              financial_reason: reason,
                                              pay_bonus_by_requalification_score: true)

  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = false, 1)
  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = false, 2)
end

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2600')
  product = Product.find_by(name: 'Recarga 99,90')
  product_reason = ProductReasonScore.create!(product: product,
                                              financial_reason: reason,
                                              pay_bonus_by_requalification_score: true)

  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = false, 1)
  create_product_scores_by_trail(product, reason, product_reason, elite_scores, fix_value = false, 2)
end
