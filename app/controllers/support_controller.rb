class SupportController < BackofficeController

  protect_from_forgery with: :exception

  before_action :ensure_admin_or_support

  private

  def ensure_admin_or_support
    return if signed_in? && (current_user.admin? || current_user.suporte?)
    flash[:error] = 'Você precisa ser admin ou suporte'
    redirect_to backoffice_dashboard_index_path
  end

end
