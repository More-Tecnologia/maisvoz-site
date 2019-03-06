module Financial
  class PayThirdOrder < ApplicationService

    def initialize(form)
      @form  = form
      @payer = form.payer
      @order = form.order
    end

    def call
      return unless form.valid?

      ActiveRecord::Base.transaction do
        debit_payer
        create_withdrawal
        pay_order
        update_order
      end
    end

    private

    attr_reader :form, :payer, :order

    def debit_payer
      FinancialEntry.new.tap do |debit|
        debit.user          = payer
        debit.order         = order
        debit.description   = "Pagamento de fatura de terceiro no valor de #{h.number_to_currency order.total} para o usuário #{order.user.username}"
        debit.amount        = -order.total
        debit.balance_cents = payer.balance_cents - order.total_cents
        debit.kind          = FinancialEntry.kinds[:third_order_payment]
        debit.save!
      end
      payer.decrement!(:available_balance_cents, order.total_cents)
    end

    def create_withdrawal
      Withdrawal.new.tap do |withdrawal|
        withdrawal.user                  = payer
        withdrawal.status                = Withdrawal.statuses[:approved_balance]
        withdrawal.gross_amount_cents    = order.total_cents
        withdrawal.net_amount_cents      = order.total_cents
        withdrawal.save!
      end
    end

    def pay_order
      PaymentCompensation.new(order).call
    end

    def update_order
      order.update!(
        payment_type: Order.payment_types[:balance],
        paid_by: payer.username
      )
    end

  end
end
