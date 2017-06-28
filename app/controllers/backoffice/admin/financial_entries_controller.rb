module Backoffice
  module Admin
    class FinancialEntriesController < AdminController

      def index
        render(:index, locals: { financial_entries: financial_entries })
      end

      private

      def financial_entries
        FinancialEntry.all.order(created_at: :desc).page(params[:page])
      end

    end
  end
end
