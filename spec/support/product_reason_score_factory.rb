class ProductReasonScoreFactory
  include FactoryBot::Syntax::Methods

  GENERATIONS = (1..6).to_a
  PRODUCT_SCORE = Faker::Number.positive.to_i

  def self.create
    new.build
  end

  def build
    products = create_products
    financial_reasons = create_financial_reasons
    trails = create_trails
    careers = create_careers
    career_trails = create_career_trails(careers, trails)
    product_scores = create_product_scores_for(products, career_trails)
    create_product_reason_scores(financial_reasons, product_scores, products)
  end

  def create_products
    Product.kinds.keys.map { |kind| create(:product, kind) }
  end

  def create_financial_reasons
    (1..3).to_a.map { create(:financial_reason) }
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

  def create_product_scores_for(products, career_trails)
    products.map do |product|
      create_product_score_for(product, career_trails)
    end
  end

  def create_product_score_for(product, career_trails)
    career_trails.map do |career_trail|
      GENERATIONS.map  do  |generation|
        ProductScore.create!(career_trail: career_trail,
                             product: product,
                             cent_amount: PRODUCT_SCORE,
                             generation: generation)
      end
    end
  end

  def create_product_reason_scores(financial_reasons, product_scores, products)
    financial_reasons.map do |financial_reason|
      product_scores.map.with_index do |product_score_by_generation, index|
        product_score_by_generation.flatten.map do |p|
          ProductReasonScore.create!(product_score: p,
                                     financial_reason: financial_reason,
                                     product: products[index])
        end
      end
    end
  end
end
