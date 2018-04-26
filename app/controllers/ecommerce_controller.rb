class EcommerceController < BackofficeController

  before_action :ensure_admin_or_ecommerce

  private

  def ensure_admin_or_ecommerce
    return if signed_in? && (current_user.admin? || current_user.ecommerce?)
    flash[:error] = 'Você precisa ser admin ou admin lojista'
    redirect_to root_path
  end

end
