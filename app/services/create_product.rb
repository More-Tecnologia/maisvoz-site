class CreateProduct

  def initialize(form)
    @form = form
  end

  def call
    return false unless form.valid?
    create_product
  end

  private

  attr_reader :form, :product

  def create_product
    @product = Product.new(form.attributes)
    product.save!
  end

end
