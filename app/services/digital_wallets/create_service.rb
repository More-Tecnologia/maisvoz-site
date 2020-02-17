# frozen_string_literal: true

module DigitalWallets
  class CreateService

    def self.call(digital_wallet, locale)
      new(digital_wallet, locale).send(:call)
    end

    def initialize(digital_wallet, locale)
      @digital_wallet = digital_wallet
      @locale = locale
    end

    private

    def call
      send_digital_wallet_confirmation if @digital_wallet.save
    end

    def send_digital_wallet_confirmation
      NotifyService.call(@digital_wallet, @locale, type: :confirmation)
    end

  end
end
