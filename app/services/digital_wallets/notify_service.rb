# frozen_string_literal: true

module DigitalWallets
  class NotifyService
    STATUS_DIRECTION = {
      pending: :reactive,
      inactive: :refused,
      active: :activated
    }.freeze

    def self.call(digital_wallet, locale, type: STATUS_DIRECTION[digital_wallet.status.to_sym])
      new(digital_wallet, locale, type).send(:call)
    end

    def initialize(digital_wallet, locale, type)
      @digital_wallet = digital_wallet
      @locale = locale
      @direction = type
    end

    private

    def call
      true if send_digital_wallet
    end

    def send_digital_wallet
      DigitalWalletsMailer.with(digital_wallet: @digital_wallet, locale: @locale)
                          .send(@direction)
                          .deliver_later
    end
  end
end
