class UpdateProduct

  def initialize(form, product)
    @form = form
    @product = product
  end

  def call
    return false unless form.valid?
    ActiveRecord::Base.transaction do
      update_product
    end
    true
  end

  private

  attr_reader :form, :product

  def update_product
    product.update!(form_attributes)
  end

  def form_attributes
    attrs = form.attributes.except(:id, :financial_reason_id, :product_scores)
    attrs = attrs.except(:main_photo) if form.main_photo.blank?
    attrs = attrs.except(:photos) if form.photos.blank?
    attrs = attrs.except(:price)
    attrs[:price_cents] = form.price.to_f * 1e2
    form_reason_scores
    attrs
  end
  
  def form_reason_scores
    product.product_reason_scores.destroy_all
    unless form.attributes[:financial_reason_id].blank?
      reason_score = ProductReasonScore.create({
        product_id: product.id,
        financial_reason_id: form.attributes[:financial_reason_id].to_i
      })
      form_scores(reason_score)
    end
  end

  def form_scores(reason_score)
    unless form.attributes[:product_scores].blank?
      form.attributes[:product_scores].each do |generation, row|
        row.each do |career_trail,value|
          ProductScore.create({
            product_reason_score_id: reason_score.id,
            career_trail_id: career_trail.to_i,
            generation: generation.to_i,
            amount_cents: value.to_f * 1e2
          })
        end
      end
    end
  end
end
