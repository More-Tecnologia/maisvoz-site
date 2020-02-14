# frozen_string_literal: true

module Emails
  class UpdateService
    def self.call(email, status, locale)
      new(email, status, locale).send(:call)
    end

    def initialize(email, status, locale)
      @email = email
      @status = status
      @locale = locale
    end

    private

    def call
      send_email_notification if email_status_change
    end

    def email_status_change
      @email.update(status: @status)
    end

    def send_email_notification
      NotifyService.call(@email, @locale)
    end
  end
end
