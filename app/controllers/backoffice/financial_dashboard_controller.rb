# frozen_string_literal: true

module Backoffice
  class FinancialDashboardController < EntrepreneurController

    before_action :ensure_no_admin_user, only: :index

    def index; end

    private

    def ensure_no_admin_user
      if user_signed_in? && (current_user.admin? || current_user.financeiro?)
        redirect_to backoffice_admin_dashboard_index_path
      end
    end

  end
end
