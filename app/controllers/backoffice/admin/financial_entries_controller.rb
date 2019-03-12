module Backoffice
  module Admin
    class FinancialEntriesController < BackofficeController

      def index
        authorize :admin_financial_entries, :index?

        render(:index, locals: { financial_entries: financial_entries, q: q })
      end

      private

      def financial_entries
        @financial_entries ||= q.result.page(params[:page])
      end

      def q
        @q ||= FinancialEntry.ransack(params[:q])
        @q.sorts = 'created_at desc' if @q.sorts.empty?
        @q
      end

    end
  end
end
