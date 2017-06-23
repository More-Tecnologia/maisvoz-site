class CreateProduct

  def initialize(form)
    @form = form
  end

  def call
    return false unless form.valid?
    ActiveRecord::Base.transaction do
      create_product
      create_cloudinary_image
    end
  end

  private

  attr_reader :form, :product

  def create_product
    @product = Product.new(form_attributes)
    product.save!
  end

  def create_cloudinary_image
    image = CloudinaryImage.new(public_id: form.public_id)
    image.imageable = product
    image.save!
  end

  def form_attributes
    form.attributes.except(:public_id_cache, :public_id)
  end

end
