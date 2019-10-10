module Backoffice
  module Admin
    class CreditsDebitsController < AdminController

      def show
        case step_path
        when :find_user
          form = find_user_form
        when :credit_debit
          form = create_form
        end
        render(step_path, locals: { form: form })
      end

      def update
        case step_path
        when :find_user
          if find_user_form.valid?
            render(:credit_debit, locals: { form: create_form })
          else
            render(:find_user, locals: { form: find_user_form })
          end
        end
      end

      def new
        render(:new, locals: { form: CreditDebitForm.new })
      end

      def create
        command = Financial::CreateCreditDebit.call(current_user, params)
        if command.success?
          flash[:success] = I18n.t('defaults.success')
          redirect_to backoffice_admin_financial_transactions_path
        else
          flash[:error] = command.errors.values.flatten.join(', ')
          redirect_back fallback_location: backoffice_admin_financial_transactions_path
        end
      end

      private

      def step_path
        @step_path ||= params[:id].to_sym
      end

      def find_user_form
        @find_user_form ||= CreditDebitWizard::FindUserForm.new(params[:credit_debit_form])
      end

      def create_form
        @create_form ||= CreditDebitWizard::CreateForm.new(params[:credit_debit_form])
      end
    end
  end
end
