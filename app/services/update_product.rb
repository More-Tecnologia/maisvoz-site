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
    CreateOrUpdateClImage.new(product, product.cloudinary_image, form.public_id).call
  end

  def form_attributes
    form.attributes.except(:id, :public_id_cache, :public_id)
  end

end
