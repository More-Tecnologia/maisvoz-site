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
    return errors.add(:voucher_code, :invalid_voucher) if voucher.blank?
    errors.add(:voucher_code, :used_voucher) if voucher.used?
  end

  def valid_order
    return errors.add(:order_id, :invalid) unless order
    return errors.add(:order_id, :invalid_order_status_for_payment) unless order.pending_payment?
    errors.add(:order_id, :only_advance_product_can_be_paid_with_voucher) unless order_has_only_advance_product?
  end

  def valid_password
    errors.add(:password, :wrong_password) unless user.valid_password?(password)
  end

  def order_has_only_advance_product?
    order.order_items.all? { |i| i.product.code == Product.advance_product_code }
  end

end
