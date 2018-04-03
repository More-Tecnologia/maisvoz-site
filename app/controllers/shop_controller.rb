class ShopController < ApplicationController

  layout 'public'

  def index
    render locals: { products: products }
  end

  private

  def products
    Product.all.includes(:cloudinary_images)
  end

end
