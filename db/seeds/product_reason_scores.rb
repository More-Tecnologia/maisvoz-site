def create_product_scores_by(product, reason, product_reason, scores, fix_value)
  @career_trails ||= CareerTrail.all
  scores.each_with_index do |generation_scores, index|
    generation_scores.each_with_index do |amount_cents, idx|
      career_trails = @career_trails.select { |c| c.career_id == idx + 1 }
      career_trails.each do |career_trail|
        product_reason.product_scores
                      .create!(career_trail: career_trail,
                               generation: index + 1,
                               amount_cents: amount_cents,
                               fix_value: true)
      end
    end
  end
end

# Direct Indication Bonus
ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2000')
  product = Product.find_by(name: 'Elite')
  product_reason = ProductReasonScore.create!(product: product, financial_reason: reason)
  scores = [[4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000]]

  create_product_scores_by(product, reason, product_reason, scores, fix_value = true)
end

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2000')
  product = Product.find_by(name: 'Premium')
  product_reason = ProductReasonScore.create!(product: product, financial_reason: reason)
  scores = [[8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000]]

  create_product_scores_by(product, reason, product_reason, scores, fix_value = true)
end

# Indirect Indication Bonus
ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2200')
  product = Product.find_by(name: 'Elite')
  product_reason = ProductReasonScore.create!(product: product, financial_reason: reason)
  scores = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500],
            [0, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500],
            [0, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500],
            [0, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500]]

  create_product_scores_by(product, reason, product_reason, scores, fix_value = true)
end

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2200')
  product = Product.find_by(name: 'Premium')
  product_reason = ProductReasonScore.create!(product: product, financial_reason: reason)
  scores = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
            [0, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
            [0, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
            [0, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000]]

  create_product_scores_by(product, reason, product_reason, scores, fix_value = true)
end

# Activation Bonus
ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2400')
  product = Product.find_by(name: 'Recarga 99,99 - Ativação')
  product_reason = ProductReasonScore.create!(product: product,
                                              financial_reason: reason,
                                              pay_bonus_by_requalification_score: true)
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

  create_product_scores_by(product, reason, product_reason, elite_scores, fix_value = true)
end

ActiveRecord::Base.transaction do
  reason = FinancialReason.find_by(code: '2400')
  product = Product.find_by(name: 'Recarga 149,90 - Ativação')
  product_reason = ProductReasonScore.create!(product: product,
                                              financial_reason: reason,
                                              pay_bonus_by_requalification_score: true)
  premium_scores = [[000, 700, 700, 700, 700, 700, 700, 700, 700, 700, 700],
                    [000, 000, 500, 500, 500, 500, 500, 500, 500, 500, 500],
                    [000, 000, 000, 300, 300, 300, 300, 300, 300, 300, 300],
                    [000, 000, 000, 000, 000, 300, 300, 300, 300, 300, 300],
                    [000, 000, 000, 000, 000, 250, 250, 250, 250, 250, 250],
                    [000, 000, 000, 000, 000, 000, 250, 250, 250, 250, 250],
                    [000, 000, 000, 000, 000, 000, 000, 200, 200, 200, 200],
                    [000, 000, 000, 000, 000, 000, 000, 000, 200, 200, 200],
                    [000, 000, 000, 000, 000, 000, 000, 000, 000, 150, 150]]

  create_product_scores_by(product, reason, product_reason, premium_scores, fix_value = true)
end
