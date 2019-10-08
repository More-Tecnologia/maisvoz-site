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
    attrs = form.attributes.except(:id)
    attrs = attrs.except(:main_photo) if form.main_photo.blank?
    attrs = attrs.except(:photos) if form.photos.blank?
    attrs = attrs.except(:price)
    attrs[:price_cents] = form.price.to_f * 1e2
    form_scores(attrs)
    attrs
  end

  def form_scores(attrs)
    product.product_scores.destroy_all
    unless attrs[:product_scores].blank?
      attrs[:product_scores].each do |generation, row|
        row.each do |career,value|
          career_trail = CareerTrail.find_by(career_id: career.to_i, trail_id: product.trail_id)
          ProductScore.create!({
            product_id: product.id,
            career_trail_id: career_trail.id,
            generation: generation.to_i,
            cent_amount: value.to_f * 1e2
          })
        end
      end
    end
  end
end
