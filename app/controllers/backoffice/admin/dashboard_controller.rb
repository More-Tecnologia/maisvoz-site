# frozen_string_literal: true

module Backoffice
  module Admin
    class DashboardController < EntrepreneurController

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

    end
  end
end
