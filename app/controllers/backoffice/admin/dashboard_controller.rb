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
        render json: { data: '' }
      end

      def withdrawals_data
        render json: { data: ''}
      end
    end
  end
end
