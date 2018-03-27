module Backoffice
  class BankAccountsController < BackofficeController

    def edit
      render_edit
    end

    def update
      if form.valid? && !form.user.bank_account_present?
        form.user = current_user
        UpdateBankAccount.new(form).call
        redirect_to(
          edit_backoffice_bank_account_path,
          alert: 'Conta bancária atualizada com sucesso'
        )
      else
        render_edit
      end
    end

    private

    def render_edit
      render :edit, locals: { form: form }
    end

    def form
      @form ||= BankAccountForm.new(form_params)
    end

    def form_params
      params[:bank_account_form]                  ||= {}
      params[:bank_account_form][:user]           ||= current_user.decorate
      params[:bank_account_form][:bank_code]      ||= current_user.bank_code
      params[:bank_account_form][:account_number] ||= current_user.bank_account.split('-')[0]
      params[:bank_account_form][:account_digit]  ||= current_user.bank_account.split('-')[1]
      params[:bank_account_form][:agency_number]  ||= current_user.bank_agency.split('-')[0]
      params[:bank_account_form][:agency_digit]   ||= current_user.bank_agency.split('-')[1]
      params[:bank_account_form]
    end

  end
end
