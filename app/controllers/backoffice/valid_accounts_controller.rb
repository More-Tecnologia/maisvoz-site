module Backoffice
  class ValidAccountsController < BackofficeController
    def create
      current_user.send_confirmation_instructions.deliver
      current_user.update(confirmation_sent_at: Time.now)
    end
  end
end
