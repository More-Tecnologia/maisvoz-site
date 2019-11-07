class AdminController < BackofficeController

  layout 'admin'

  before_action :ensure_admin

  private

  def ensure_admin
    return if signed_in? && current_user.admin?
    flash[:error] = 'Você precisa ser administrador.'
    redirect_to backoffice_dashboard_index_path
  end

end
