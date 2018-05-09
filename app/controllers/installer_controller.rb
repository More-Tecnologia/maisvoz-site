class InstallerController < BackofficeController

  before_action :ensure_admin_or_installer

  private

  def ensure_admin_or_installer
    return if signed_in? && (current_user.admin? || current_user.instalador?)
    flash[:error] = 'Você precisa ser admin ou instalador'
    redirect_to backoffice_dashboard_index_path
  end

end
