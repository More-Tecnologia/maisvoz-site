module Backoffice
  module Admin
    class FinancialEntriesController < AdminController

      def index
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
