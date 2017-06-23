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
  end

  private

  attr_reader :form, :product

  def update_product
    product.update!(form_attributes)
  end

  def cl_update
    return if form.public_id == product.cloudinary_image.public_id || form.public_id.blank?
    destroy_cl_image
    create_cl_image
  end

  def create_cl_image
    image = CloudinaryImage.new(public_id: form.public_id)
    image.imageable = product
    image.save!
  end

  def destroy_cl_image
    # Cloudinary::Uploader.destroy(product.cloudinary_image.public_id)
    product.cloudinary_image.remove_public_id!
    product.cloudinary_image.destroy!
  end

  def form_attributes
    form.attributes.except(:id, :public_id_cache, :public_id)
  end

end
