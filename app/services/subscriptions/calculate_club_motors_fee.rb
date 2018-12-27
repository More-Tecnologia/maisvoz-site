module Subscriptions
  class CalculateClubMotorsFee

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
      @package_level = DefineUserPackage.new(product: product).call
    end

  end
end
