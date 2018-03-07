class FinancialController < BackofficeController

  protect_from_forgery with: :exception

  before_action :ensure_admin_or_financial

  private

  def ensure_admin_or_financial
    return if signed_in? && (current_user.admin? || current_user.financeiro?)
    flash[:error] = 'Você precisa ser admin ou financeiro'
    redirect_to backoffice_dashboard_index_path
  end

end
