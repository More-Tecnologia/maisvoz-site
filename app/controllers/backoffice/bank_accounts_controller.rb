module Backoffice
  class BankAccountsController < EntrepreneurController

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
      params[:bank_account_form][:account_number] ||= bank_account.split('-')[0]
      params[:bank_account_form][:account_digit]  ||= bank_account.split('-')[1]
      params[:bank_account_form][:agency_number]  ||= bank_agency.split('-')[0]
      params[:bank_account_form][:agency_digit]   ||= bank_agency.split('-')[1]
      params[:bank_account_form]
    end

    def bank_account
      return '' if current_user.bank_account.blank?
      current_user.bank_account
    end

    def bank_agency
      return '' if current_user.bank_agency.blank?
      current_user.bank_agency
    end

  end
end
