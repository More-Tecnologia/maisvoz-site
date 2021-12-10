module Backoffice
  class ValidAccountsController < BackofficeController
    def new
      Devise::Mailer.confirmation_instructions(current_user, current_user.confirmation_token)
                    .deliver_later

      flash[:alert] = t('.success', email: current_user.email)
      redirect_to backoffice_home_index_path
    end
  end
end
