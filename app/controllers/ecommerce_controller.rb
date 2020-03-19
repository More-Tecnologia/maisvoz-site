class EcommerceController < BackofficeController

  before_action :ensure_admin_or_ecommerce

  private

  def ensure_admin_or_ecommerce
    return if signed_in? && (current_user.admin? || current_user.ecommerce?)
    flash[:error] = 'You need to be admin or shopkeeper admin'
    redirect_to root_path
  end

end
