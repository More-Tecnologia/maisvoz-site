module Vouchers
  class Create

    def initialize(user:, product:)
      @user    = user
      @product = product
    end

    def call
      vouchers_count.times do
        create_voucher
      end
    end

    private

    attr_reader :user, :product

    def vouchers_count
      product.quantity.to_i
    end

    def create_voucher
      Voucher.create!(user: user)
    end

  end
end
