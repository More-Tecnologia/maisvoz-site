module Backoffice
  class TransfersController < BackofficeController

    def new
      render(:new, locals: { form: TransferForm.new })
    end

    def create
      command = Financial::TransferCredit.call(current_user, params)

      if command.success?
        flash[:success] = I18n.t('defaults.success')
        redirect_to backoffice_admin_financial_entries_path
      else
        render(:new, locals: { form: command.result })
      end
    end

  end
end
