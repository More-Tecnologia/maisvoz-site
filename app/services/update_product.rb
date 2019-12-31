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
    attrs = form.attributes.except(:id, :financial_reason, :product_scores, :product_scores_fix)
    attrs = attrs.except(:main_photo) if form.main_photo.blank?
    attrs = attrs.except(:photos) if form.photos.blank?
    attrs = attrs.except(:price)
    attrs[:price_cents] = form.price.to_f * 1e2
    form_reason_scores
    attrs
  end

  def form_reason_scores
    unless form.attributes[:financial_reason].blank?
      form.attributes[:financial_reason].each do |row, financial_reason_id|
        reason_score = ProductReasonScore.create({
          product_id: product.id,
          financial_reason_id: financial_reason_id.to_i
        })
        form_scores(row, reason_score)
      end
    end
  end

  def form_scores(financial_reason, reason_score)
    unless form.attributes[:product_scores].nil? || form.attributes[:product_scores][financial_reason].nil?
      form.attributes[:product_scores][financial_reason].each do |generation, row|
        row.each do |career_trail,value|
          ProductScore.create({
            product_reason_score_id: reason_score.id,
            career_trail_id: career_trail.to_i,
            generation: generation.to_i,
            amount_cents: value.to_f * 1e2,
            fix_value: form.attributes[:product_scores_fix][financial_reason][generation][career_trail] == '1'
          })
        end
      end
    end
  end
end
