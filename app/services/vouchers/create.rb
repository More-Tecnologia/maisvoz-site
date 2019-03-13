module Vouchers
  class Create

    VOUCHERS = {
      standard: 5,
      master: 10,
      premium: 15
    }.freeze

    def initialize(order)
      @order = order
    end

    def call
      define_package

      vouchers_count.times do
        create_voucher
      end
    end

    private

    attr_reader :order, :package

    def vouchers_count
      VOUCHERS[package]
    end

    def create_voucher
      Voucher.create!(
        user: order.user
      )
    end

    def define_package
      @package = DefineUserPackage.new(product: order.adhesion_product).call
    end

  end
end
