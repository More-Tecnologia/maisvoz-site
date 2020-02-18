# frozen_string_literal: true

module DigitalWallets
  class UpdateService
    def self.call(digital_wallet, status, locale)
      new(digital_wallet, status, locale).send(:call)
    end

    def initialize(digital_wallet, status, locale)
      @digital_wallet = digital_wallet
      @status = status
      @locale = locale
    end

    private

    def call
      send_digital_wallet_notification if digital_wallet_status_change
    end

    def digital_wallet_status_change
      @digital_wallet.update(status: @status)
    end

    def send_digital_wallet_notification
      NotifyService.call(@digital_wallet, @locale)
    end
  end
end
