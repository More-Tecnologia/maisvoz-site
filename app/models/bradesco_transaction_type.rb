class BradescoTransactionType

  WAITING_PAYMENT       = 'waiting_payment'.freeze
  BOLETO_GENERATED      = '10'.freeze
  GENERATED_UNCONFIRMED = '13'.freeze
  GENERATED_CONFIRMED   = '14'.freeze
  PAID_MANUAL           = '15'.freeze
  CANCELLED             = '16'.freeze
  PAID_EQUAL            = '21'.freeze
  PAID_LESS             = '22'.freeze
  PAID_MORE             = '23'.freeze

  def self.all
    [WAITING_PAYMENT, BOLETO_GENERATED, GENERATED_UNCONFIRMED, GENERATED_CONFIRMED, PAID_MANUAL, CANCELLED, PAID_EQUAL, PAID_LESS, PAID_MORE]
  end

  def self.enum
    {
      WAITING_PAYMENT       => WAITING_PAYMENT,
      BOLETO_GENERATED      => BOLETO_GENERATED,
      GENERATED_UNCONFIRMED => GENERATED_UNCONFIRMED,
      GENERATED_CONFIRMED   => GENERATED_CONFIRMED,
      PAID_MANUAL           => PAID_MANUAL,
      CANCELLED             => CANCELLED,
      PAID_EQUAL            => PAID_EQUAL,
      PAID_LESS             => PAID_LESS,
      PAID_MORE             => PAID_MORE
    }
  end

end
