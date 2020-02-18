# frozen_string_literal: true

module Emails
  class NotifyService
    STATUS_DIRECTION = {
      pending: :reactive,
      inactive: :refused,
      active: :activated
    }.freeze

    def self.call(email, locale, type: STATUS_DIRECTION[email.status.to_sym])
      new(email, locale, type).send(:call)
    end

    def initialize(email, locale, type)
      @email = email
      @locale = locale
      @direction = type
    end

    private

    def call
      true if send_email
    end

    def send_email
      EmailsMailer.with(email: @email, locale: @locale)
                  .send(@direction)
                  .deliver_later
    end
  end
end
