class CreateProduct

  def initialize(form)
    @form = form
  end

  def call
    return false unless form.valid?
    ActiveRecord::Base.transaction do
      create_product
    end
    true
  end

  private

  attr_reader :form, :product

  def create_product
    @product = Product.new(form_attributes)
    product.save!
  end

  def form_attributes
    attrs = form.attributes
    attrs = attrs.except(:price)
    attrs[:price_cents] = form.price.to_f * 1e2
    attrs
  end

end
