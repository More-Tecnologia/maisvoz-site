module Backoffice
  class BankAccountsController < BackofficeController

    def edit; end

    def update
      @user = current_user
      if current_user.update!(valid_params)
        redirect_to edit_backoffice_bank_account_path, alert: t('.success')
      else
        render :edit
      end
    end

    private

    def valid_params
      params.require(:user)
            .permit(:wallet_address, :pix_wallet)
    end

  end
end
