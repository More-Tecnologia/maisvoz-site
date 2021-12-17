module Backoffice
  class ValidAccountsController < BackofficeController
    def create
      Devise::Mailer.confirmation_instructions(current_user, current_user.confirmation_token)
                    .deliver_later
      current_user.update(confirmation_sent_at: Time.now)
    end
  end
end
