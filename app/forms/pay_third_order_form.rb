class PayThirdOrderForm < Form

  attribute :invoice_id
  attribute :document_cpf
  attribute :password
  attribute :payer

  validates :invoice_id, :document_cpf, :password, presence: true

  validate :correct_password
  validate :user_exists
  validate :order_exists
  validate :not_your_invoice, if: -> { order.present? }
  validate :order_adhesion, if: -> { order.present? }
  validate :payer_has_balance, if: -> { order.present? }
  validate :order_is_pending, if: -> { order.present? }

  def order
    @order ||= Order.find_by(id: Order.decode_id(invoice_id))
  end

  private

  def correct_password
    return if payer.valid_password?(password)
    errors.add(:password, 'Senha incorreta')
  end

  def user_exists
    return if User.exists?(document_cpf: document_cpf)
    errors.add(:document_cpf, 'Não encontrado')
  end

  def not_your_invoice
    return if order.user_id != payer.id
    errors.add(:invoice_id, 'Não pode pagar sua própria fatura')
  end

  def order_exists
    return if order.present?
    errors.add(:invoice_id, 'Fatura não existente')
  end

  def order_adhesion
    return if order.order_items.count == 1 && order.order_items.first.product.adhesion?
    errors.add(:invoice_id, 'Fatura não corresponde a uma adesão')
  end

  def payer_has_balance
    return if payer.available_balance >= order.total
    errors.add(:invoice_id, 'Você não possui saldo o suficiente')
  end

  def order_is_pending
    return if order.pending_payment?
    errors.add(:invoice_id, 'A fatura já está paga')
  end

end
