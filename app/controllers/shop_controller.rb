class ShopController < ApplicationController

  before_action :ensure_signed_out

  layout 'public'

  def index
    render locals: { products: products }
  end

  def show
    render locals: { product: product }
  end

  private

  def products
    Product.all.includes(:cloudinary_images)
  end

  def product
    Product.find(params[:id])
  end

  def ensure_signed_out
    redirect_to backoffice_products_path if user_signed_in?
  end

end
