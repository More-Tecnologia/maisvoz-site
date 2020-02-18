# frozen_string_literal: true

module Emails
  class CreateService

    def self.call(email, locale)
      new(email, locale).send(:call)
    end

    def initialize(email, locale)
      @email = email
      @locale = locale
    end

    private

    def call
      send_email_confirmation if @email.save
    end

    def send_email_confirmation
      Emails::NotifyService.call(@email, @locale, type: :confirmation)
    end

  end
end
