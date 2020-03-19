# frozen_string_literal: true

module Backoffice
  module Admin
    class DashboardController < AdminController

      skip_before_action :ensure_admin
      before_action :ensure_admin_financial_support

      def index
        @index = Dashboards::Admins::IndexPresenter.new
      end

      def bonus_data
        render json: Dashboards::Admins::BonusPresenter.new
                                                       .build
      end

      def payment_data
        render json: Dashboards::Admins::PaymentPresenter.new.build
      end

      def withdrawals_data
        render json: Dashboards::Admins::WithdrawalsPresenter.new.build
      end

      private

      def ensure_admin_financial_support
        return if signed_in? && (current_user.admin? || current_user.suporte? || current_user.financeiro?)
        flash[:error] = 'You must be an admin, financial or support user'
        redirect_to backoffice_dashboard_index_path
      end

    end
  end
end
