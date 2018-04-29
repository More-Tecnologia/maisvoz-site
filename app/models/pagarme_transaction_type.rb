class PagarmeTransactionType

  PROCESSING = 'processing'.freeze
  AUTHORIZED = 'authorized'.freeze
  PAID = 'paid'.freeze
  REFUNDED = 'refunded'.freeze
  WAITING_PAYMENT = 'waiting_payment'.freeze
  PENDING_REFUND = 'pending_refund'.freeze
  REFUSED = 'refused'.freeze
  CHARGEBACK = 'chargeback'.freeze

  def self.all
    [PROCESSING, AUTHORIZED, PAID, REFUNDED, WAITING_PAYMENT, PENDING_REFUND, REFUSED, CHARGEBACK]
  end

  def self.enum
    {
      PROCESSING      => PROCESSING,
      AUTHORIZED      => AUTHORIZED,
      PAID            => PAID,
      REFUNDED        => REFUNDED,
      WAITING_PAYMENT => WAITING_PAYMENT,
      PENDING_REFUND  => PENDING_REFUND,
      REFUSED         => REFUSED,
      CHARGEBACK      => CHARGEBACK
    }
  end

end
