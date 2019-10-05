class ProductReasonScoreFactory
  include FactoryBot::Syntax::Methods

  GENERATIONS = (1..6).to_a
  CENT_AMOUNT = 1
  FINANCIAL_REASONS_COUNT = 3

  def self.create
    new.build
  end

  def build
    products = create_products
    financial_reasons = create_financial_reasons
    trails = create_trails
    careers = create_careers
    career_trails = create_career_trails(careers, trails)
    product_reason_scores = create_product_reason_scores(products, financial_reasons)
    create_product_scores_for(product_reason_scores, career_trails)
  end

  def create_products
    Product.kinds.keys.map { |kind| create(:product, kind) }
  end

  def create_financial_reasons
    (1..FINANCIAL_REASONS_COUNT).to_a.map { create(:financial_reason) }
  end

  def create_trails
    (1..3).to_a.map { create(:trail) }
  end

  def create_careers
    (1..3).to_a.map { create(:career) }
  end

  def create_career_trails(careers, trails)
    careers.map { |career|
      trails.map do |trail|
        CareerTrail.create!(career: career,
                            trail: trail)
      end
    }.flatten
  end

  def create_product_reason_scores(products, financial_reasons)
    products.map { |product|
      financial_reasons.map  do |financial_reason|
        ProductReasonScore.create!(product: product,
                                   financial_reason: financial_reason)
      end
    }.flatten
  end

  def create_product_scores_for(product_reason_scores, career_trails)
    product_reason_scores.map { |product_reason_score|
      career_trails.map do |career_trail|
        create_product_score_by_generation(product_reason_score, career_trail)
      end
    }.flatten
  end

  def create_product_score_by_generation(product_reason_score, career_trail)
    GENERATIONS.map do |generation|
      ProductScore.create!(product_reason_score: product_reason_score,
                           career_trail: career_trail,
                           generation: generation,
                           cent_amount: CENT_AMOUNT)
    end
  end
end
