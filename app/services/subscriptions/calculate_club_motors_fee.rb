module Subscriptions
  class CalculateClubMotorsFee

    STANDARD = 'standard'.freeze
    MASTER   = 'master'.freeze
    PREMIUM  = 'premium'.freeze

    def initialize(product:, fee:)
      @product = product
      @fee = fee

      define_package
    end

    def call
      return if package_level.blank?

      fee.send("#{package_level}_fee_cents")
    end

    private

    attr_reader :product, :fee, :package_level

    def define_package
      return if product.blank?

      if include_package?(STANDARD)
        @package_level = :standard
      elsif include_package?(MASTER)
        @package_level = :master
      elsif include_package?(PREMIUM)
        @package_level = :premium
      end
    end

    def include_package?(package)
      product.name.downcase.include?(package)
    end

  end
end