module Payment
  class CreateTransaction

    def initialize(order)
      @order = order
      @user  = order.user.decorate
    end

    def call
      transaction = PagarMe::Transaction.new(params).charge

      create_pagarme_transaction(transaction)
    end

    private

    attr_reader :order, :user

    def create_pagarme_transaction(tx)
      PagarmeTransaction.new.tap do |record|
        record.user                   = order.user
        record.order                  = order
        record.boleto_url             = tx.boleto_url
        record.boleto_barcode         = tx.boleto_barcode
        record.boleto_expiration_date = tx.boleto_expiration_date
        record.amount_cents           = tx.amount
        record.pagarme_tid            = tx.tid
        record.status                 = tx.status
        record.installments           = tx.installments
        record.save!
      end
    end

    def params
      {
        amount: order.total_cents,
        payment_method: 'boleto',
        postback_url: ENV['PAGARME_POSTBACK_URL'],
        customer: {
          name: user.name,
          email: user.email,
          document_number: user.main_document,
          phone_numbers: [user.phone]
        },
        metadata: {
          idPedido: order.id,
          subtotal: order.subtotal,
          tax: order.tax,
          shipping: order.shipping,
          total: order.total
        }
      }
    end

  end
end
