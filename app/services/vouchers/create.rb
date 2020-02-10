module Vouchers
  class Create

    def initialize(user:, order:)
      @user = user
      @order = order
    end

    def call
      vouchers_count.times do
        create_voucher
      end
    end

    private

    attr_reader :user, :order

    def vouchers_count
      voucher_products = order.order_items.select { |i| i.product.voucher? }
      voucher_products.sum { |i| i.quantity.to_i * i.product.quantity.to_i }
    end

    def create_voucher
      Voucher.create!(user: user)
    end

  end
end
