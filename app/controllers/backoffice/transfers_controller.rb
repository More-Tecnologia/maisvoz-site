module Backoffice
  class TransfersController < EntrepreneurController

    def show
      case step_path
      when :find_user
        form = find_user_form
      when :new_transfer
        form = transfer_form
        redirect_to(
          backoffice_transfer_path(:find_user),
          notice: I18n.t('errors.messages.not_found')
        ) && return if form.to_user.blank?
      end
      render(step_path, locals: { form: form })
    end

    def update
      case step_path
      when :find_user
        if find_user_form.valid?
          render(:new_transfer, locals: { form: transfer_form })
        else
          render(step_path, locals: { form: find_user_form })
        end
      end
    end

    def create
      command = Financial::TransferCredit.call(current_user, params)

      if command.success?
        flash[:success] = I18n.t('defaults.success')
        redirect_to backoffice_financial_entries_path
      else
        flash[:error] = I18n.t('defaults.error')
        render(:new_transfer, locals: { form: transfer_form })
      end
    end

    private

    def step_path
      @step_path ||= params[:id].to_sym
    end

    def find_user_form
      @find_user_form ||= TransferWizard::FindUserForm.new(params[:transfer_form])
    end

    def transfer_form
      @transfer_form ||= TransferWizard::TransferForm.new(params[:transfer_form])
    end

  end
end
