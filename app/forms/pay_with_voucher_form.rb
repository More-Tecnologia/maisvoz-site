class PayWithVoucherForm < Form

  attribute :voucher_code
  attribute :order_id
  attribute :password
  attribute :user

  validates :voucher_code, :order_id, :password, presence: true

  validate :valid_voucher
  validate :valid_order
  validate :valid_password

  def voucher
    @voucher ||= user.vouchers.where(code: voucher_code).first
  end

  def order
    @order ||= Order.find_by_hashid(order_id)
  end

  private

  def valid_voucher
    return if voucher_code.blank?

    if voucher.blank?
      errors.add(:voucher_code, 'Cupom inválido')
    elsif voucher
      errors.add(:voucher_code, 'Cupom já utilizado') if voucher.used?
    end
  end

  def valid_order
    return if order_id.blank? || order.futurepro_adhesion?

    if order.blank?
      errors.add(:order_id, 'Pedido inválido')
    elsif order.completed?
      errors.add(:order_id, 'Pedido já está pago')
    elsif !order.monthly_fee?
      errors.add(:order_id, 'Pedido não é do tipo assinatura')
    elsif !(order.payable.clubmotors? || order.payable.ancore?)
      errors.add(:order_id, 'Pedido não é do tipo +Você ou Ancore')
    elsif order.payable.orders.count > 1
      errors.add(:order_id, 'Pedido não pode ser pago pois possui mais de uma fatura')
    end
  end

  def valid_password
    return if user.valid_password?(password)

    errors.add(:password, 'Senha incorreta')
  end

end
