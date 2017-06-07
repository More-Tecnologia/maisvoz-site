class DestroyProduct

  def initialize(product)
    @product = product
  end

  def call
    destroy_product
  end

  private

  attr_reader :product

  def destroy_product
    product.destroy!
  end

end
