class UpdateProduct

  def initialize(form, product)
    @form = form
    @product = product
  end

  def call
    return false unless form.valid?
    update_product
  end

  private

  attr_reader :form, :product

  def update_product
    product.update!(form.attributes)
  end

end
