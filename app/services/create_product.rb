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
    form.attributes
  end

end
