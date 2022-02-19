module Backoffice
  module Admin
    class PoolExpensesController < AdminController
      before_action :validate_master_password, only: :create

      def new
        @financial_transaction = FinancialTransaction.new
      end

      def create
        @financial_transaction = FinancialTransaction.new(valid_params)
        if @financial_transaction.valid?(:expense) && @financial_transaction.save
          flash[:success] = t('.success')
          redirect_to new_backoffice_admin_expense_path
        else
          flash[:error] = @financial_transaction.errors.full_messages.join(', ')
          render :new
        end
      end

      private

      def valid_params
        attributes = params.require(:financial_transaction)
                           .permit(:cent_amount, :note)
                           .merge(user: User.find_morenwm_customer_admin,
                                  financial_reason: FinancialReason.pool_expense_wallet)
        attributes[:cent_amount] = cleasing_decimal_number(attributes[:cent_amount])
        attributes
      end

      def validate_master_password
        master_password = params[:financial_transaction][:master_password]
        return if authenticate_master_password?(master_password)
        flash[:error] = t('defaults.unauthenticate_master_password')
        redirect_to new_backoffice_admin_expense_path
      end
    end
  end
end
