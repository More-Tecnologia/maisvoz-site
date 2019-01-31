module Trackers
  class CalculateAdhesionPrice

    DISCOUNTS = {
      standard: 0.2,
      master: 0.3,
      premium: 0.4
    }.freeze

    def initialize(user:, tracker:)
      @user = user
      @tracker = tracker
    end

    def call
      define_package
      tracker.price - tracker.price * discount
    end

    private

    attr_reader :user, :package, :tracker

    def discount
      return 0 if package.blank?

      DISCOUNTS[package]
    end

    def define_package
      @package = DefineUserPackage.new(product: user.product).call
    end

  end
end
