module Vouchers
  class Apply

    def initialize(order:, payer:, voucher:)
      @order = order
      @payer = payer
      @voucher = voucher
    end

    def call
      ActiveRecord::Base.transaction do
        update_user
        update_order
        update_voucher
      end
    end

    private

    attr_reader :order, :payer, :voucher

    def update_user
      order.user.update!(role: 'empreendedor')
    end

    def update_order
      order.update!(
        total_cents: 0,
        subtotal_cents: 0,
        payment_type: Order.payment_types[:voucher],
        paid_by: payer.username,
        status: :completed
      )
    end

    def update_voucher
      voucher.update!(
        used: true,
        used_at: Time.zone.now,
        order: order,
        invoice_type: (order.payable.type unless order.payable.nil?)
      )
    end

  end
end
