class EntrepreneurController < BackofficeController

  before_action :ensure_admin_or_entrepreneur

  private

  def ensure_admin_or_entrepreneur
    return if signed_in? && (current_user.admin? || current_user.empreendedor?)
    redirect_to root_path
  end

end
