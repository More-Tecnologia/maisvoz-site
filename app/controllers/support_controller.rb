class SupportController < BackofficeController

  before_action :ensure_admin_or_support

  private

  def ensure_admin_or_support
    return if signed_in? && (current_user.admin? || current_user.suporte? || current_user.financeiro?)
    flash[:error] = 'You must be admin or support'
    redirect_to '/'
  end

end
