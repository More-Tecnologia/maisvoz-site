module Backoffice
  class FinancialEntriesController < EntrepreneurController

    prepend_before_action :ensure_admin_or_entrepreneur

    def index
      render(:index, locals: { financial_entries: financial_entries })
    end

    private

    def financial_entries
      AccountFinancialEntriesQuery.new(current_user).call.page(params[:page])
    end

    def ensure_admin_or_entrepreneur
      return if signed_in? && (current_user.admin? || current_user.empreendedor? || current_user.instalador?)
      flash[:error] = 'Você precisa ser admin ou empreendedor'
      redirect_to root_path
    end

  end
end
