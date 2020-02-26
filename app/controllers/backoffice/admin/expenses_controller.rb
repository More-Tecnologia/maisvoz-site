module Backoffice
  module Admin
    class ExpensesController < AdminController

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
                                  financial_reason: FinancialReason.expense)
        cleasing_cent_amount(attributes)
        attributes
      end

      def cleasing_cent_amount(attributes)
        attributes[:cent_amount] = attributes[:cent_amount].to_s.gsub('.','')
                                                                .gsub(',','.')
                                                                .to_f
      end

    end
  end
end
