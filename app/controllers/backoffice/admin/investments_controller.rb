module Backoffice
  module Admin
    class InvestmentsController < AdminController

      def index
        @investments = Investment.all.order(:id)
      end

      def new
        render(:new, locals: { investment: Investment.new })
      end

      def create
        if new_investment.valid? && new_investment.save!
          flash[:success] = 'Conta de participação criada com sucesso'
          redirect_to backoffice_admin_investments_path
        else
          render(:new, locals: { investment: new_investment })
        end
      end

      def edit
        render(:edit, locals: { investment: edit_investment })
      end

      def update
        edit_investment.assign_attributes(investment_params)
        if edit_investment.valid? && edit_investment.update!(investment_params)
          flash[:success] = 'Conta de participação atualiada com sucesso'
          redirect_to backoffice_admin_investments_path
        else
          render(:edit, locals: { investment: edit_investment })
        end
      end

      private

      def render_edit
        render(:edit, locals: { investment: investment })
      end

      def new_investment
        @new_investment ||= Investment.new(investment_params)
      end

      def edit_investment
        @edit_investment ||= Investment.find(params[:id])
      end

      def investment_params
        params.fetch(:investment, {}).permit!
      end

    end
  end
end
