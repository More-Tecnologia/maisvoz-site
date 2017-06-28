module Backoffice
  module Admin
    class CreditsDebitsController < AdminController

      def new
        render(:new, locals: { form: CreditDebitForm.new })
      end

      def create
        command = Financial::CreateCreditDebit.call(current_user, params)

        if command.success?
          flash[:success] = I18n.t('defaults.success')
          redirect_to backoffice_admin_financial_entries_path
        else
          render(:new, locals: { form: command.result })
        end
      end

    end
  end
end
