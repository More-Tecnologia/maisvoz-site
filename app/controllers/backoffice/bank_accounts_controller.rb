module Backoffice
  class BankAccountsController < BackofficeController

    def edit; end

    def update
      @user = current_user
      if valid_params[:wallet_address].present?
        current_user.update!(wallet_address: valid_params[:wallet_address])
        redirect_to edit_backoffice_bank_account_path, alert: t('.success')
      else
        render :edit
      end
    end

    private

    def valid_params
      params.require(:user)
            .permit(:bank_code, :bank_account_type, :account_number, :account_digit,
                    :agency_digit, :account_number, :wallet_address)
    end

  end
end
