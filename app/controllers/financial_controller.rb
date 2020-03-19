class FinancialController < BackofficeController

  before_action :ensure_admin_or_financial

  private

  def ensure_admin_or_financial
    return if signed_in? && (current_user.admin? || current_user.financeiro? || current_user.suporte?)
    flash[:error] = t(:must_be_admin_or_financial)
    redirect_to backoffice_dashboard_index_path
  end

end
