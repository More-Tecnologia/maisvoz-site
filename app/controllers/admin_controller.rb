class AdminController < BackofficeController

  protect_from_forgery with: :exception

  layout 'admin'

  before_action :ensure_admin

  private

  def ensure_admin
    return if signed_in? && current_user.admin?
    flash[:error] = 'You need to be admin'
    redirect_to backoffice_dashboard_index_path
  end

end
