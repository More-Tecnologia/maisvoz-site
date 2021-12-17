# frozen_string_literal: true

module Backoffice
  module HomeHelper
    def confirmation_email_sent_in_less_than_24_hours?
      if current_user.confirmation_sent_at.present?
        (current_user.confirmation_sent_at + 1.day) > Time.now
      else
        false
      end
    end

    def activation_email_time
      seconds_to_hms((current_user.confirmation_sent_at + 1.day) - Time.now)
    end
  end
end
