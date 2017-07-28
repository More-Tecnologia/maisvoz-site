class UpdateProduct

  def initialize(form, product)
    @form = form
    @product = product
  end

  def call
    return false unless form.valid?
    ActiveRecord::Base.transaction do
      update_product
      cl_update
    end
    true
  end

  private

  attr_reader :form, :product

  def update_product
    product.update!(form_attributes)
  end

  def cl_update
    return if form.images.blank?
    form.images.each do |image|
      CreateOrUpdateClImage.new(product, nil, image).call
    end
  end

  def form_attributes
    form.attributes.except(:id, :public_id_cache, :images)
  end

end
