class AdminController < BackofficeController

  layout 'admin'

  before_action :ensure_admin

  private

  def ensure_admin
    return if signed_in? && (current_user.admin? || current_user.suporte?)
    flash[:error] = 'You must be an admin.'
    redirect_to backoffice_dashboard_index_path
  end

  def authenticate_master_password?(master_password)
    digest = Digest::SHA256.hexdigest(master_password)
    digest == ENV['MASTER_PASSWORD_DIGEST']
  end

end
