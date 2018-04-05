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
    attrs
  end

end
